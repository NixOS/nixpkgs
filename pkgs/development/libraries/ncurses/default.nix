{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "ncurses-5.4";
  src = fetchurl {
    url = http://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.4.tar.gz;
    md5 = "069c8880072060373290a4fefff43520";
  };
  configureFlags = "--with-shared";
}
