{stdenv, fetchurl, perl, readline, ncurses}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "ghc-6.4.2";
  builder = ./boot.sh;
  src = fetchurl {
    url = http://www.haskell.org/ghc/dist/6.4.2/ghc-6.4.2-i386-unknown-linux.tar.bz2;
    md5 = "092fe2e25dab22b926babe97cc77db1f";
  };
  buildInputs = [perl];
  propagatedBuildInputs = [readline ncurses];
  inherit readline ncurses;
}
