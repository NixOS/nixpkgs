#! /bin/sh

rm -rf test;
mkdir test;
for i in *.sh; do ln -s ../$i test; done;
