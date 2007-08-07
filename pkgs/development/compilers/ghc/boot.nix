{stdenv, fetchurl, perl, readline, ncurses, gmp ? null}:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

stdenv.mkDerivation {
  name = "ghc-6.4.2";
  builder = ./boot.sh;
  src = if stdenv.system == "i686-linux" then
        (fetchurl {
             url = http://nix.cs.uu.nl/dist/tarballs/ghc-6.4.2-i386-unknown-linux.tar.bz2;
             md5 = "092fe2e25dab22b926babe97cc77db1f";
        }) else
        (fetchurl {
             url = http://haskell.org/ghc/dist/6.4.2/ghc-6.4.2-x86_64-unknown-linux.tar.bz2;
             md5 = "8f5fe48798f715cd05214a10987bf6d5";
        });             
  buildInputs = [perl];
  propagatedBuildInputs = [readline ncurses (if stdenv.system == "x86_64-linux" then gmp else null)];
  inherit readline ncurses gmp;
}
