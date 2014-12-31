{stdenv, fetchurl, readline, ghc, perl, m4, gmp, ncurses}:

stdenv.mkDerivation (rec {
  version = "6.8.2";
  name = "ghc-${version}";
  homepage = "http://www.haskell.org/ghc";

  src = map fetchurl [
    { url = "${homepage}/dist/${version}/${name}-src.tar.bz2";
      sha256 = "2d10f973c35e8d7d9f62b53e26fef90177a9a15105cda4b917340ba7696a22d9";
    }
    { url = "${homepage}/dist/${version}/${name}-src-extralibs.tar.bz2";
      md5 = "d199c50814188fb77355d41058b8613c";
    }
  ];

  buildInputs = [ghc readline perl m4 gmp];

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

  preConfigure = "
    # still requires a hack for ncurses
    sed -i \"s|^\\\(ld-options.*$\\\)|\\\1 -L${ncurses}/lib|\" libraries/readline/readline.buildinfo.in
  ";
})
