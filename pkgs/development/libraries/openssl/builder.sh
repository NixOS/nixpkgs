. $stdenv/setup || exit 1
export PATH=$perl/bin:$PATH

tar xvfz $src || exit 1
cd openssl-* || exit 1
./config --prefix=$out shared || exit 1
make || exit 1
mkdir $out || exit 1
make install || exit 1

# Bug fix: openssl does a `chmod 644' on the pkgconfig directory.
chmod 755 $out/lib/pkgconfig || exit 1

echo $envpkgs > $out/envpkgs || exit 1
