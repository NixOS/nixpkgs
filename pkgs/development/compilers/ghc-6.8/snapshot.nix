{stdenv, fetchurl, readline, ghc, perl, m4, gmp, ncurses}:

stdenv.mkDerivation (rec {
  name = "ghc-6.8.2.20080602";
  homepage = "http://www.haskell.org/ghc";

  src = map fetchurl [
    { url    = "${homepage}/dist/stable/dist/${name}-src.tar.bz2";
      sha256 = "06374d2a65671a21b4ce44a84333cedf4a5f5e0adbb837e8985c6b46b5de4249";
    }
    { url    = "${homepage}/dist/stable/dist/${name}-src-extralibs.tar.bz2";
      sha256 = "0dfea592d6be5838fa7db85a65b7d38b97451b829afe3b03a790350a9591b470";
    }
  ];

  buildInputs = [ghc readline perl m4 gmp];

  # The setup hook is executed by other packages building with ghc.
  # It then looks for package configurations that are available and
  # build a package database on the fly.
  setupHook = ./setup-hook.sh;

  meta = {
    description = "The Glasgow Haskell Compiler";
  };

  configureFlags=[
    "--with-gmp-libraries=${gmp}/lib"
    "--with-gmp-includes=${gmp}/include"
    "--with-readline-libraries=${readline}/lib"
    "--with-gcc=${gcc}/bin/gcc"
  ];

  preConfigure = "
    # still requires a hack for ncurses
    sed -i \"s|^\\\(ld-options.*$\\\)|\\\1 -L${ncurses}/lib|\" libraries/readline/readline.buildinfo.in
  ";

  inherit (stdenv) gcc;
  inherit readline gmp ncurses;
})
