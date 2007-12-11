{stdenv, fetchurl, readline, ghc, perl, m4, gmp, ncurses}:

stdenv.mkDerivation (rec {
  name = "ghc-6.8.1";
  homepage = "http://www.haskell.org/ghc";

  src = map fetchurl [
    { url = "${homepage}/dist/stable/dist/${name}-src.tar.bz2";
      md5 = "8d47d4dcde96c31fe8bedcee7f99eaf1";
    }
    { url = "${homepage}/dist/stable/dist/${name}-src-extralibs.tar.bz2";
      md5 = "f91de87e7c0a3fe2f27c5a83212d9743";
    }
  ];

  buildInputs = [ghc readline perl m4];

  setupHook = ./setup-hook.sh;

  meta = {
    description = "The Glasgow Haskell Compiler v6.8.1";
  };

  postInstall = "
    ensureDir \"$out/nix-support\"
    echo \"# Path to the GHC compiler directory in the store\" > $out/nix-support/setup-hook
    echo \"ghc=$out\" >> $out/nix-support/setup-hook
    echo \"\"         >> $out/nix-support/setup-hook
    cat $setupHook    >> $out/nix-support/setup-hook
  ";

  patch64 = ./x86_64-linux_patch;

  # Thanks to Ian Lynagh ghc now works on x86_64-linux as well 
  patchPhase = if (stdenv.system == "x86_64-linux") then "patch -p2 < $patch64" else "";

  configureFlags="--with-gmp-libraries=${gmp}/lib --with-readline-libraries=${readline}/lib";

  preConfigure = "
    # the presence of this file makes Cabal cry for happy while generating makefiles ...
    rm libraries/haskell-src/Language/Haskell/Parser.ly
    # still requires a hack for ncurses
    sed -i \"s|^\\\(ld-options.*$\\\)|\\\1 -L${ncurses}/lib|\" libraries/readline/readline.buildinfo.in
  ";

  inherit readline gmp ncurses;
})
