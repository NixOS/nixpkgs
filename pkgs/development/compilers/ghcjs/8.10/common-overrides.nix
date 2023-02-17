{ haskellLib, fetchpatch, buildPackages }:

let inherit (haskellLib) addBuildTools appendConfigureFlag dontHaddock doJailbreak markUnbroken overrideCabal;
in self: super: {
  ghcjs = overrideCabal (drv: {
    # Jailbreak and patch can be dropped after https://github.com/ghcjs/ghcjs/pull/833
    jailbreak = true;
    patches = drv.patches or [] ++ [
      (fetchpatch {
        name = "ghcjs-aeson-2.0.patch";
        url = "https://github.com/ghcjs/ghcjs/commit/9ef1f92d740e8503d15d91699f57db147f0474cc.patch";
        sha256 = "0cgxcy6b5870bv4kj54n3bzcqinh4gl4w4r78dg43h2mblhkzbnj";
      })
    ];
  }) (super.ghcjs.overrideScope (self: super: {
    # Allow transformers-compat >= 0.7
    optparse-applicative = doJailbreak self.optparse-applicative_0_15_1_0;
  }));
}
