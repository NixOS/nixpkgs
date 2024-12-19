if [ -e "$NIX_ATTRS_SH_FILE" ]; then . "$NIX_ATTRS_SH_FILE"; elif [ -f .attrs.sh ]; then . .attrs.sh; fi
source $stdenv/setup

pkgdir=$(pwd)/pkg
deploydir=$(pwd)/deploy

undmg $src
mkdir $out
mkdir $pkgdir
mkdir $deploydir

pkg=*.mpkg/Contents/Packages/*.pkg
xar -xf $pkg -C $pkgdir
pushd $deploydir
cat $pkgdir/Payload | gunzip -dc | cpio -i
popd
echo $deploydir
cp -r $deploydir/usr/local/* $out
