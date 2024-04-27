if [ -e "$NIX_ATTRS_SH_FILE" ]; then . "$NIX_ATTRS_SH_FILE"; elif [ -f .attrs.sh ]; then . .attrs.sh; fi
source $stdenv/setup

tar xf $src
cd */
tarballdir=$(pwd)
for i in *.tar; do tar xvf $i; done
echo "Deploying binaries.."
mkdir $out
cd $out
for i in $tarballdir/*.gz; do tar xvf $i; done
echo 'Creating ppc* symlink..'
for i in $out/lib/fpc/*/ppc*; do
  ln -fs $i $out/bin/$(basename $i)
done
