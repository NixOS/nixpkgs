buildinputs="$pkgconfig $perl $glib $libxml2 $GConf $libbonobo \
  $gnomemimedata $popt $bzip2"
. $stdenv/setup || exit 1

tar xvfj $src || exit 1
cd gnome-vfs-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1
strip -S $out/lib/*.a || exit 1
