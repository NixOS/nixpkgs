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
    optparse-applicative = self.optparse-applicative_0_15_1_0;
    webdriver = overrideCabal (drv: {
      patches = drv.patches or [] ++ [
        # Patch for aeson 2.0 which adds a lower bound on it, so we don't apply it globally
        # Pending https://github.com/kallisti-dev/hs-webdriver/pull/183
        (fetchpatch {
          name = "webdriver-aeson-2.0.patch";
          url = "https://github.com/georgefst/hs-webdriver/commit/90ded63218da17fc0bd9f9b208b0b3f60b135757.patch";
          sha256 = "1xvkk51r2v020xlmci5n1fd1na8raa332lrj7r9f0ijsyfvnqlv0";
          excludes = [ "webdriver.cabal" ];
        })
      ];
      # Fix line endings so patch applies
      prePatch = drv.prePatch or "" + ''
        find . -name '*.hs' | xargs "${buildPackages.dos2unix}/bin/dos2unix"
      '';

      jailbreak = true;
      broken = false;
    }) super.webdriver;
  }));
}
