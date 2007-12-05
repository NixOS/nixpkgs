{stdenv, fetchurl, readline, ghc, perl, m4, gmp, ncurses}:

stdenv.mkDerivation (rec {
  name = "ghc-6.8.0.20071018";
  homepage = "http://www.haskell.org/ghc";

  src = map fetchurl [
    { url = "${homepage}/dist/stable/dist/${name}-src.tar.bz2";
      md5 = "7e61bd2a55c2d6ed5a6d996d19d3f6bf";
    }
    { url = "${homepage}/dist/stable/dist/${name}-src-extralibs.tar.bz2";
      md5 = "7b155c1d1e7daa492cc2161b3828a377";
    }
  ];

  buildInputs = [ghc readline perl m4];

  setupHook = ./setup-hook.sh;

  meta = {
    description = "The Glasgow Haskell Compiler v6.8 (snapshot)";
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
  patchPhase = if (stdenv.system == "x86_64-linx") then "patch -p2 < $patch64" else "";

  configureFlags="--with-gmp-libraries=$gmp/lib --with-readline-libraries=\"$readline/lib\"";

  # the presence of this file makes Cabal cry for happy while generating makefiles ...
  preConfigure = "
    echo 'GhcThreaded=NO' > mk/build.mk
    rm libraries/haskell-src/Language/Haskell/Parser.ly
  ";

  inherit readline gmp ncurses;
})
