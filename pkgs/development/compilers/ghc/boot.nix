{stdenv, fetchurl, perl}:

assert perl != null;

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "ghc-6.2.1";
  src = fetchurl {
    url = http://www.haskell.org/ghc/dist/6.2.1/ghc-6.2.1-i386-unknown-linux.tar.bz2;
    md5 = "48d9d6b9f7bf1f15d69e8bd732ee254c";
  };
  buildInputs = [perl];
}
