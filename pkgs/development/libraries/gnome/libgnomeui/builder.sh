buildinputs="$pkgconfig $libgnome $libgnomecanvas $libbonoboui $libglade"
. $stdenv/setup

tar xvfj $src
cd libgnomeui-*
./configure --prefix=$out
make
make install
strip -S $out/lib/*.a $out/lib/libglade/*/*.a

mkdir $out/nix-support
echo "$libgnome $libgnomecanvas $libbonoboui" > $out/nix-support/propagated-build-inputs
