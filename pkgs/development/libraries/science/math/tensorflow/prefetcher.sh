#!/usr/bin/env bash

# ./prefetcher.sh 2.4.0 binary-hashes.nix

version="$1"
hashfile="$2"
rm -f $hashfile
echo "{" >> $hashfile
echo "version = \"$version\";" >> $hashfile
for sys in "linux" "darwin"; do
    for tfpref in "cpu" "gpu"; do
        for platform in "x86_64"; do
            if [ $sys = "darwin" ] && [ $tfpref = "gpu" ]; then
               continue
            fi
            url=https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-$tfpref-$sys-$platform-$version.tar.gz
            hash=$(nix-prefetch-url $url)
            echo "\"${tfpref}-${sys}-${platform}\" = {" >> $hashfile
            echo "  url = \"$url\";" >> $hashfile
            echo "  sha256 = \"$hash\";" >> $hashfile
            echo "};" >> $hashfile
        done
    done
done
echo "}" >> $hashfile

