buildinputs="$pkgconfig $x11 $glib $atk $pango $perl $libtiff $libjpeg $libpng"
. $stdenv/setup

IFS=:
for i in $PATH; do echo $i; done

#exit 1
# A utility function for fixing up libtool scripts that scan in
# default directories like /usr.  This is a bit of a hack.  A better
# solution would be to fix libtool, but since it is included in so
# many packages that is not feasible right now.

tar xvfj $src
cd gtk+-*
fixLibtool ltmain.sh
./configure --prefix=$out
make
make install

mkdir $out/nix-support
echo "$x11 $glib $atk $pango" > $out/nix-support/propagated-build-inputs
