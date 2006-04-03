source $stdenv/setup

mkdir -p $out
unpackPhase
mv $directory/* $out
