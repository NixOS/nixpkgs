source $stdenv/setup

unzip $src
cd hsqldb*
mkdir -p $out
cp -R * $out/
