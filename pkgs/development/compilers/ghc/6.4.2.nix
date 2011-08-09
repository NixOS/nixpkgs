{stdenv, fetchurl, perl, ghc, m4, readline, ncurses, gmp}:

stdenv.mkDerivation {
  name = "ghc-6.4.2";

  src = fetchurl {
    url = http://www.haskell.org/ghc/dist/6.4.2/ghc-6.4.2-src.tar.bz2;
    md5 = "a394bf14e94c3bca5507d568fcc03375";
  };

  buildInputs = [perl ghc m4];

  propagatedBuildInputs = [readline ncurses gmp];

  configureFlags = "--with-gcc=${stdenv.gcc}/bin/gcc";

  preConfigure =
    ''
      # Don't you hate build processes that write in $HOME? :-(
      export HOME=$(pwd)/fake-home
      mkdir -p $HOME
    '';

  meta = {
    description = "The Glasgow Haskell Compiler";
    platforms = ghc.meta.platforms;
  };
}
