source $stdenv/setup

configureFlags="--with-aterm=$aterm --with-sdf=$sdf --with-strategoxt=$strategoxt"
genericBuild

# Replace /bin/bash in WebDSL script (maybe there is a better solution?)

sed -i -e "s|#!/bin/bash|#!/bin/sh|" $out/bin/webdsl
