{stdenv, fetchurl, perl, ghc, m4}:

assert perl != null && ghc != null && m4 != null;

derivation {
  name = "ghc-6.2";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.haskell.org/ghc/dist/6.2/ghc-6.2-src.tar.bz2;
    md5 = "cc495e263f4384e1d6b38e851bf6eca0";
  };
  inherit stdenv perl ghc m4;
}
