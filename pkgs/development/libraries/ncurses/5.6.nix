args: with args;

stdenv.mkDerivation {
  name = "ncurses-5.6";
  src = fetchurl {
    url = mirror://gnu/ncurses/ncurses-5.6.tar.gz;
    sha256 = "1m94axgq3y9c4ld0sba63rls1611fncra49ppijpv8w32srw5jpr";
  };
  configureFlags = [ "--with-shared" "--without-normal"
    "--includedir=\${out}/include" "--without-debug"]
    ++ (if unicode then ["--enable-widec"] else []);
  postInstall= if unicode then "
    chmod -v 644 $out/lib/libncurses++w.a
    for lib in curses ncurses form panel menu; do
      echo \"INPUT(-l\${lib}w)\" > $out/lib/lib\${lib}.so
    done
    echo \"INPUT(-lncursesw)\" > $out/lib/libcursesw.so
  " else "
    chmod -v 644 $out/lib/libncurses++.a
    echo \"INPUT(-lncurses)\" > $out/lib/libcurses.so
  ";
}
