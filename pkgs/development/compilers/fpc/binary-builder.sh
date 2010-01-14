source $stdenv/setup

tar xf $src
tarballdir=$(pwd)
for i in *.tar; do tar xvf $i; done
echo "Deploying binaries.."
mkdir $out
cd $out
for i in $tarballdir/*.gz; do tar xvf $i; done
echo "Creating ppc386 symlink.."
ln -fs $out/lib/fpc/*/ppc386 $out/bin/ppc386

