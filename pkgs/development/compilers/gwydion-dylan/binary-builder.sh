. $stdenv/setup

set -e

mkdir -p $out
cd $out
tar zxvf $src
mv ./usr/local/* .
rm -rf ./usr
