source $stdenv/setup

tar xf $src
tarballdir=$(pwd)
for i in *.tar; do tar xf $i; done
mkdir $out
cd $out
for i in $tarballdir/*.gz; do tar xf $i; done
ln -fs $out/lib/fpc/*/ppc386 $out/bin

