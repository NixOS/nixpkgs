source $stdenv/setup

mkdir -p $out
mkdir -p $out/site-packages

export PYTHON_SITE=$out/site-packages
configureFlags="--with-python=$python/bin/python --disable-apache --disable-perl --disable-ruby --disable-java --disable-csharp"

genericBuild
