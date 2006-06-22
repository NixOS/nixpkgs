{stdenv, gcc, fetchurl, perl, ghc, m4, readline, ncurses}:

stdenv.mkDerivation {
  name = "ghc-6.4.2";
  src = fetchurl {
    url = http://www.haskell.org/ghc/dist/6.4.2/ghc-6.4.2-src.tar.bz2;
    md5 = "a394bf14e94c3bca5507d568fcc03375";
  };
  buildInputs = [perl ghc m4];
  propagatedBuildInputs = [readline ncurses];
  builder = ./builder.sh;
  inherit gcc;
}
