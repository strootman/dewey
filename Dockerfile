FROM clojure:alpine

RUN apk add --update git && \
    rm -rf /var/cache/apk

VOLUME ["/etc/iplant/de"]

WORKDIR /usr/src/app

COPY project.clj /usr/src/app/
RUN lein deps

COPY conf/main/logback.xml /usr/src/app/
COPY . /usr/src/app

RUN lein uberjar && \
    cp target/dewey-standalone.jar .

RUN ln -s "/usr/bin/java" "/bin/dewey"

ENTRYPOINT ["dewey", "-Dlogback.configurationFile=/etc/iplant/de/logging/dewey-logging.xml", "-cp", ".:dewey-standalone.jar", "dewey.core"]
CMD ["--help"]

ARG git_commit=unknown
ARG version=unknown

LABEL org.cyverse.git-ref="$git_commit"
LABEL org.cyverse.version="$version"
