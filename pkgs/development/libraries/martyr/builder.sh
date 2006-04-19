source $stdenv/setup

mkdir -p $out
unpackPhase
cd $name
$apacheAnt/bin/ant
cp -R ./* $out
