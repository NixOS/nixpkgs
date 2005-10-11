{stdenv, fetchurl, perl, readline, ncurses}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "ghc-6.4.1";
  builder = ./boot.sh;
  src = fetchurl {
    url = http://www.haskell.org/ghc/dist/6.4.1/ghc-6.4.1-i386-unknown-linux.tar.bz2;
    md5 = "9cd18a8e946da91b373b8ec855cd842e";
  };
  buildInputs = [perl];
  propagatedBuildInputs = [readline ncurses];
  inherit readline ncurses;
}
