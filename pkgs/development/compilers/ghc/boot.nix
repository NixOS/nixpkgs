{stdenv, fetchurl, perl}:

assert perl != null;

assert stdenv.system == "i686-linux";

derivation {
  name = "ghc-6.2";
  system = stdenv.system;
  builder = ./boot.sh;
  src = fetchurl {
    url = http://www.haskell.org/ghc/dist/6.2/ghc-6.2-i386-unknown-linux.tar.bz2;
    md5 = "5b2f19ca00fd7494002047d7fb4dce3e";
  };
  inherit stdenv perl;
}
