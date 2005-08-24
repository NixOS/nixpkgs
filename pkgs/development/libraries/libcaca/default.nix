{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "libcaca-0.9";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://sam.zoy.org/libcaca/libcaca-0.9.tar.bz2;
    md5 = "c7d5c46206091a9203fcb214abb25e4a";
  };
  inherit ncurses;
  propagatedBuildInputs = [ncurses];
}
