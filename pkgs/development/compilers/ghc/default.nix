{stdenv, fetchurl, perl, ghc, m4}:

assert perl != null && ghc != null && m4 != null;

stdenv.mkDerivation {
  name = "ghc-6.2.1";
  src = fetchurl {
    url = http://www.haskell.org/ghc/dist/6.2.1/ghc-6.2.1-src.tar.bz2;
    md5 = "fa9f90fd6b8852679c5fc16509e94d7a";
  };
  buildInputs = [perl ghc m4];
}
