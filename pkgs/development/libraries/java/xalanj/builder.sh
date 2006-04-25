source $stdenv/setup

unpackPhase
mkdir -p $out
cp -r $directory/* $out
