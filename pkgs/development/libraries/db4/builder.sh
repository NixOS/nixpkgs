. $stdenv/setup || exit 1

tar xvfz $src || exit 1
cd db-*/build_unix || exit 1
../dist/configure --prefix=$out --enable-cxx --enable-compat185 || exit 1
make || exit 1
make install || exit 1
rm -rf $out/doc || exit 1
