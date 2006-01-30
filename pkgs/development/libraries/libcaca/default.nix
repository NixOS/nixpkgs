{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "libcaca-0.9";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/libcaca-0.9.tar.bz2;
    md5 = "c7d5c46206091a9203fcb214abb25e4a";
  };
  configureFlags = "--disable-x11 --disable-imlib2 --disable-doc";
  propagatedBuildInputs = [ncurses];
}
