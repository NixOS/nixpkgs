
stdenv.mkDerivation (rec {
  homepage = "http://www.haskell.org/ghc";

  src = map fetchurl [
    { url = "${homepage}/dist/stable/dist/${name}-src.tar.bz2";
    }
    { url = "${homepage}/dist/stable/dist/${name}-src-extralibs.tar.bz2";
    }
  ];


  setupHook = ./setup-hook.sh;

  meta = {
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


  # the presence of this file makes Cabal cry for happy while generating makefiles ...
  preConfigure = "
    echo 'GhcThreaded=NO' > mk/build.mk
    rm libraries/haskell-src/Language/Haskell/Parser.ly
  ";
})
