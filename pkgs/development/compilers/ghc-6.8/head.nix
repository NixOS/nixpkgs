{stdenv, fetchurl, readline, ghc, perl, m4, gmp, ncurses}:

stdenv.mkDerivation (rec {
  name = "ghc-6.9.20080615";
  homepage = "http://www.haskell.org/ghc";

  src = map fetchurl [
    { url    = "${homepage}/dist/current/dist/${name}-src.tar.bz2";
      sha256 = "705a43506a4e4c2449c26eb5179c810dbeab7eda519c222670e67313eae167c1";
    }
    { url    = "${homepage}/dist/current/dist/${name}-src-extralibs.tar.bz2";
      sha256 = "39c573e57346069d80adff61cea239d382f66c43201948e4cee4305bb58eca88";
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

  # preConfigure = "
  #   # still requires a hack for ncurses
  #   sed -i \"s|^\\\(ld-options.*$\\\)|\\\1 -L${ncurses}/lib|\" libraries/readline/readline.buildinfo.in
  # ";

  preConfigure = ''
    # should not be present in a clean distribution
    rm utils/pwd/pwd
  '';

  inherit (stdenv) gcc;
  inherit readline gmp ncurses;
})
