source $stdenv/setup

export CXXFLAGS="-m32"

tar zxvf "$gecodeSrc"
cd gecode-1.3.1
./configure --prefix="$out" --disable-minimodel --disable-examples
make
make install
cd ..

PKG_CONFIG_PATH=$PKG_CONFIG_PATH:"$out"/lib/pkgconfig

tar zxvf "$seamSrc"
cd seam-1.4
./configure --prefix="$out" --with-zlib=$zlib
make
make install
cd ..

PATH=$PATH:"$out"/bin

tar zxvf "$aliceSrc"
cd alice-1.4
sed -i -e 's/bin\/bash/usr\/bin\/env bash/g' bin/alicerun.in
sed -i -e 's/bin\/bash/usr\/bin\/env bash/g' bin/aliceremote
./configure --prefix="$out" --with-gmp=$gmp
make
make install
cd ..

tar zxvf "$aliceGecodeSrc"
cd alice-gecode-1.4
make compiledll MUST_GENERATE=no
make installdll MUST_GENERATE=no
cd ..

tar zxvf "$aliceRegexSrc"
cd alice-regex-1.4
make compiledll MUST_GENERATE=no
make installdll MUST_GENERATE=no
cd ..

tar zxvf "$aliceSqliteSrc"
cd alice-sqlite-1.4
make compiledll MUST_GENERATE=no
make installdll MUST_GENERATE=no
cd ..

tar zxvf "$aliceXmlSrc"
cd alice-xml-1.4
make compiledll MUST_GENERATE=no
make installdll MUST_GENERATE=no
cd ..

tar zxvf "$aliceGtkSrc"
cd alice-gtk-1.4
sed -i -e 's/PRIVATE_GTK_LEAVE_PENDING/PRIVATE_GTK_HAS_POINTER/g' NativeGtk.cc
sed -i -e 's/bin\/bash/usr\/bin\/env bash/g' myinstall
make compiledll MUST_GENERATE=no
make installdll MUST_GENERATE=no
cd ..

tar zxvf "$aliceRuntimeSrc"
cd alice-runtime-1.4
./configure --prefix="$out"
make
make install
cd ..


