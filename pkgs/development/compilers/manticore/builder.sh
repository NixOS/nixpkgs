#!/bin/bash

source $stdenv/setup
echo "Building Manticore research compiler."
set -xe

PATH=$smlnj/bin:$PATH

mkdir -p $out/bin

# Manticore seems to use the MLB files from the build tree,
# so for now we copy the whole build tree into the store:
cd $out/
tar xf $src
mv manticore* repo_checkout
cd repo_checkout/
# TODO: At the very least, this could probably be cut down to a subset
# of the repo.

${autoconf}/bin/autoheader -Iconfig
${autoconf}/bin/autoconf -Iconfig
./configure --prefix=$out
make build -j
make install
