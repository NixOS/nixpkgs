source $stdenv/setup

unzip $src
cd hsqldb*
ensureDir $out
cp -R * $out/
