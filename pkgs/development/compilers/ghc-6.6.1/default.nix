{stdenv, fetchurl, readline, ghc, perl, m4, gmp, ncurses}:

stdenv.mkDerivation (rec {
  name = "ghc-6.6.1";

  src = map fetchurl [
    { url = http://www.haskell.org/ghc/dist/6.6.1/ghc-6.6.1-src.tar.bz2;
      md5 = "ba9f4aec2fde5ff1e1548ae69b78aeb0";
    }
    { url = http://www.haskell.org/ghc/dist/6.6.1/ghc-6.6.1-src-extralibs.tar.bz2;
      md5 = "43a26b81608b206c056adc3032f7da2a";
    }
  ];

  buildInputs = [ghc readline perl m4 gmp];

  setupHook = ./setup-hook.sh;

  meta = {
    description = "The Glasgow Haskell Compiler";
  };

  postInstall = ''
    ensureDir "$out/nix-support"
    echo "# Path to the GHC compiler directory in the store" > $out/nix-support/setup-hook
    echo "ghc=$out" >> $out/nix-support/setup-hook
    echo ""         >> $out/nix-support/setup-hook
    cat $setupHook  >> $out/nix-support/setup-hook
  '';

  configureFlags=[
    "--with-gmp-libraries=${gmp}/lib"
    "--with-readline-libraries=${readline}/lib"
    "--with-gmp-includes=${gmp}/include"
    "--with-gcc=${gcc}/bin/gcc"
  ];

  preConfigure = ''
    # still requires a hack for ncurses
    sed -i "s|^\(library-dirs.*$\)|\1 \"${ncurses}/lib\"|" libraries/readline/package.conf.in
  '';

  inherit (stdenv) gcc;
  inherit readline gmp ncurses;
})
