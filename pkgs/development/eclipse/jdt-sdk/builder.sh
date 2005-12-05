set -e

source $stdenv/setup

unzip $src 
mkdir $out
mv eclipse $out/
