{ pkgs }:

with import ./lib.nix;

self: super: {

  # Disable GHC 7.8.x core libraries.
  array = null;
  base = null;
  binary = null;
  bin-package-db = null;
  bytestring = null;
  Cabal = null;
  containers = null;
  deepseq = null;
  directory = null;
  filepath = null;
  ghc-prim = null;
  haskeline = self.haskeline_0_7_1_3;   # GHC's version is broken: https://github.com/NixOS/nixpkgs/issues/5616.
  haskell2010 = null;
  haskell98 = null;
  hoopl = null;
  hpc = null;
  integer-gmp = null;
  old-locale = null;
  old-time = null;
  pretty = null;
  process = null;
  rts = null;
  template-haskell = null;
  terminfo = self.terminfo_0_4_0_0;     # GHC's version is broken: https://github.com/NixOS/nixpkgs/issues/5616.
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  # mtl 2.2.x needs the latest transformers.
  mtl_2_2_1 = super.mtl_2_2_1.override { transformers = self.transformers_0_4_2_0; };
}

//                              # packages related to ghcjs

{
  ghcjs-prim = self.mkDerivation {
    pname = "ghcjs-prim";
    version = "0.1.0.0";
    src = pkgs.fetchgit {
      url = git://github.com/ghcjs/ghcjs-prim.git;
      rev = "8e003e1a1df10233bc3f03d7bbd7d37de13d2a84";
      sha256 = "11k2r87s58wmpxykn61lihn4vm3x67cm1dygvdl26papifinj6pz";
    };
    buildDepends = with self; [ primitive ];
    license = "unknown";
  };

  ghcjs = self.callPackage ../compilers/ghcjs { Cabal = self.Cabal_1_22_0_0; };
}

//                              # packages related to amazonka

(let
  amazonkaEnv = self: super: {
    mkDerivation = drv: super.mkDerivation (drv // { doCheck = false; });
    mtl = self.mtl_2_2_1;
    nats = self.nats_0_2;
    transformers = self.transformers_0_4_2_0;
    transformers-compat = overrideCabal super.transformers-compat (drv: { configureFlags = []; });
  };
in
{
  # These packages need mtl 2.2.x to compile.
  amazonka-core = super.amazonka-core.overrideScope amazonkaEnv;
  amazonka = super.amazonka.overrideScope amazonkaEnv;
  amazonka-cloudwatch = super.amazonka-cloudwatch.overrideScope amazonkaEnv;
})
