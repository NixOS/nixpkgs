{ pkgs }:

with import ./lib.nix { inherit pkgs; };

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

// # packages relating to amazonka

(let
  amazonkaEnv = let self_ = self; in self: super: {
    mkDerivation = drv: (super.mkDerivation.override {
      inherit (self_) jailbreak-cabal;
    }) (drv // {
      doCheck = false;
    });
    mtl = self.mtl_2_2_1;
    transformers = self.transformers_0_4_2_0;
    transformers-compat = overrideCabal super.transformers-compat (drv: { configureFlags = []; });
    aeson = disableCabalFlag super.aeson "old-locale";
    hscolour = super.hscolour;
    time = self.time_1_5_0_1;
    unix = self.unix_2_7_1_0;
    directory = self.directory_1_2_1_0;
    process = overrideCabal self.process_1_2_1_0 (drv: {
      coreSetup = true;
    });
  } // (builtins.listToAttrs (map (name: {
    inherit name;
    value = overrideCabal super.${name} (drv: {
      extraLibraries = (drv.extraLibraries or []) ++ [ self.Cabal_1_18_1_6 ];
    });
  }) [
    "conduit-extra"
    "streaming-commons"
    "http-client"
    "cryptohash-conduit"
    "xml-conduit"
  ]));
  Cabal = self.Cabal_1_18_1_6.overrideScope amazonkaEnv;
in {
  amazonka-core =
    overrideCabal (super.amazonka-core.overrideScope amazonkaEnv) (drv: {
      # https://github.com/brendanhay/amazonka/pull/57
      prePatch = "sed -i 's|nats >= 0.1.3 && < 1|nats|' amazonka-core.cabal";

      extraLibraries = (drv.extraLibraries or []) ++ [ Cabal ];
    });
})
