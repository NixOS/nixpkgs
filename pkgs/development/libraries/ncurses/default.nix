{stdenv, fetchurl, unicode ? true}:

stdenv.mkDerivation {
  name = "ncurses-5.6";
  
  src = fetchurl {
    url = mirror://gnu/ncurses/ncurses-5.6.tar.gz;
    md5 = "b6593abe1089d6aab1551c105c9300e3";
  };
  
  configureFlags =
    "--with-shared --includedir=\${out}/include" +
    (if unicode then " --enable-widec " else " ") +
    " --without-debug";
    
  preBuild = ''sed -e "s@\([[:space:]]\)sh @\1''${SHELL} @" -i */Makefile Makefile'';

  # When building a wide-character (Unicode) build, create backward
  # compatibility links from the the "normal" libraries to the
  # wide-character libraries (e.g. libncurses.so to libncursesw.so).
  postInstall = if unicode then "
    chmod -v 644 $out/lib/libncurses++w.a
    for lib in curses ncurses form panel menu; do
      if test -e $out/lib/lib\${lib}w.a; then
        rm -vf $out/lib/lib\${lib}.so
        echo \"INPUT(-l\${lib}w)\" > $out/lib/lib\${lib}.so
        ln -svf lib\${lib}w.a $out/lib/lib\${lib}.a
        ln -svf lib\${lib}w.so.5 $out/lib/lib\${lib}.so.5
      fi
    done;
  " else "";
}
