{ pkgs, lib }:

self:
pkgs.haskell.packages.ghc92.override {
  overrides =
    self: super:
    let
      inherit (pkgs.haskell.lib.compose) justStaticExecutables overrideCabal doJailbreak;
      elmPkgs = rec {
        /*
          The elm-format expression is updated via a script in the https://github.com/avh4/elm-format repo:
          `package/nix/build.sh`
        */
        elm-format = justStaticExecutables (
          overrideCabal (drv: {
            jailbreak = true;
            doHaddock = false;
            postPatch = ''
              mkdir -p ./generated
              cat <<EOHS > ./generated/Build_elm_format.hs
              module Build_elm_format where
              gitDescribe :: String
              gitDescribe = "${drv.version}"
              EOHS
            '';

            description = "Formats Elm source code according to a standard set of rules based on the official Elm Style Guide";
            homepage = "https://github.com/avh4/elm-format";
            license = lib.licenses.bsd3;
            maintainers = with lib.maintainers; [
              avh4
              turbomack
            ];
          }) (self.callPackage ./elm-format/elm-format.nix { })
        );
      };

      fixHaddock = overrideCabal (_: {
        configureFlags = [ "--ghc-option=-Wno-error=unused-packages" ];
        doHaddock = false;
      });
    in
    elmPkgs
    // {
      inherit elmPkgs;

      # Needed for elm-format
      avh4-lib = fixHaddock (doJailbreak (self.callPackage ./elm-format/avh4-lib.nix { }));
      elm-format-lib = fixHaddock (doJailbreak (self.callPackage ./elm-format/elm-format-lib.nix { }));
      elm-format-test-lib = fixHaddock (self.callPackage ./elm-format/elm-format-test-lib.nix { });
      elm-format-markdown = fixHaddock (self.callPackage ./elm-format/elm-format-markdown.nix { });

      # elm-format requires text >= 2.0
      text = self.text_2_0_2;
      # unorderd-container's tests indirectly depend on text < 2.0
      unordered-containers = overrideCabal (drv: { doCheck = false; }) super.unordered-containers;
      # relude-1.1.0.0's tests depend on hedgehog < 1.2, which indirectly depends on text < 2.0
      relude = overrideCabal (drv: { doCheck = false; }) super.relude;
    };
}
