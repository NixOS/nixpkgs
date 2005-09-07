set -e

. $stdenv/setup

unzip $src 
mkdir $out
mv eclipse $out/
