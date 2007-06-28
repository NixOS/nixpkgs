{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "ncurses-5.6";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/ncurses/ncurses-5.6.tar.gz;
    md5 = "b6593abe1089d6aab1551c105c9300e3";
  };
  configureFlags="--with-shared --includedir=\${out}/include --enable-widec --without-debug";
  postInstall="
    chmod -v 644 $out/lib/libncurses++w.a
    for lib in curses ncurses form panel menu; do
      rm -vf $out/lib/lib\${lib}.so
      echo \"INPUT(-l\${lib}w)\" > $out/lib/lib\${lib}.so
      ln -svf lib\${lib}w.a $out/lib/lib\${lib}.a
      ln -svf lib\${lib}w.so.5 $out/lib/lib\${lib}.so.5
    done;
  ";
}
