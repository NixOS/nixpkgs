buildinputs="$zlib $libjpeg"
. $stdenv/setup

tar xvfz $src
cd tiff-*
./configure --prefix=$out --with-DIR_MAN=$out/man \
 --with-ZIP --with-JPEG \
 --with-DIRS_LIBINC="$zlib/include $libjpeg/include"
make
mkdir $out
make install
strip -S $out/lib/*.a

mkdir $out/nix-support
echo "$zlib $libjpeg" > $out/nix-support/propagated-build-inputs
