. $stdenv/setup || exit 1

tar xvfz $src || exit 1
cd jpeg-* || exit 1
./configure --prefix=$out --enable-shared || exit 1
make || exit 1
mkdir $out || exit 1
mkdir $out/bin || exit 1
mkdir $out/lib || exit 1
mkdir $out/include || exit 1
mkdir $out/man || exit 1
mkdir $out/man/man1 || exit 1
make install || exit 1
