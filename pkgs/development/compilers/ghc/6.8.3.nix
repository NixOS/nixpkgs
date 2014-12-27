{stdenv, fetchurl, readline, ghc, perl, m4, gmp, ncurses, haddock}:

stdenv.mkDerivation rec {
  version = "6.8.3";
  name = "ghc-${version}";
  homepage = "http://www.haskell.org/ghc";

  src = map fetchurl [
    { url    = "${homepage}/dist/${version}/${name}-src.tar.bz2";
      sha256 = "1fc1ff82a555532f1c9d2dc628fd9de5e6ebab2ce6ee9490a34174ceb6f76e6b";
    }
    { url    = "${homepage}/dist/${version}/${name}-src-extralibs.tar.bz2";
      sha256 = "ee2f5ba6a46157fc53eae515cb6fa1ed3c5023e7eac15981d92af0af00ee2ba2";
    }
  ];

  buildInputs = [ghc readline perl m4 gmp haddock];

  meta = {
    description = "The Glasgow Haskell Compiler";
    inherit (ghc.meta) license platforms;
  };

  configureFlags=[
    "--with-gmp-libraries=${gmp}/lib"
    "--with-gmp-includes=${gmp}/include"
    "--with-readline-libraries=${readline}/lib"
    "--with-gcc=${stdenv.cc}/bin/gcc"
  ];

  preConfigure = ''
    # still requires a hack for ncurses
    sed -i "s|^\(ld-options.*$\)|\1 -L${ncurses}/lib|" libraries/readline/readline.buildinfo.in
    # build haddock docs
    echo "HADDOCK_DOCS = YES" >> mk/build.mk
  '';
}
