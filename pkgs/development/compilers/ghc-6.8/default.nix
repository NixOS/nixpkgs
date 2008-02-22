{stdenv, fetchurl, readline, ghc, perl, m4, gmp, ncurses}:

stdenv.mkDerivation (rec {
  name = "ghc-6.8.2";
  homepage = "http://www.haskell.org/ghc";

  src = map fetchurl [
    { url = "${homepage}/dist/stable/dist/${name}-src.tar.bz2";
      md5 = "745c6b7d4370610244419cbfec4b2f84";
    }
    { url = "${homepage}/dist/stable/dist/${name}-src-extralibs.tar.bz2";
      md5 = "d199c50814188fb77355d41058b8613c";
    }
  ];

  buildInputs = [ghc readline perl m4 gmp];

  setupHook = ./setup-hook.sh;

  meta = {
    description = "The Glasgow Haskell Compiler";
  };

  configureFlags=[
    "--with-gmp-libraries=${gmp}/lib"
    "--with-readline-libraries=${readline}/lib"
    "--with-gmp-includes=${gmp}/include"
    "--with-gcc=${gcc}/bin/gcc"
  ];

  preConfigure = "
    # still requires a hack for ncurses
    sed -i \"s|^\\\(ld-options.*$\\\)|\\\1 -L${ncurses}/lib|\" libraries/readline/readline.buildinfo.in
  ";

  inherit (stdenv) gcc;
  inherit readline gmp ncurses;
})
