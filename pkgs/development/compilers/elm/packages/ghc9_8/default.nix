{ pkgs, lib }:

self:
pkgs.haskell.packages.ghc98.override {
  overrides =
    self: super:
    let
      inherit (pkgs.haskell.lib.compose) justStaticExecutables overrideCabal;

      elmPkgs = {
        # Post-patch override taken from the upstream repository:
        # https://github.com/avh4/elm-format/blob/e7e5da37716acbfb4954a88128b5cc72b2c911d9/package/nix/generate_derivation.sh
        elm-format = justStaticExecutables (
          overrideCabal (drv: {
            postPatch = ''
              mkdir -p ./generated
              cat <<EOHS > ./generated/Build_elm_format.hs
              module Build_elm_format where
              gitDescribe :: String
              gitDescribe = "${drv.version}"
              EOHS
            '';

            homepage = "https://github.com/avh4/elm-format";
            maintainers = with lib.maintainers; [
              avh4
              turbomack
            ];
          }) (self.callPackage ./elm-format/elm-format.nix { })
        );
      };
    in
    elmPkgs
    // {
      inherit elmPkgs;

      # Needed for elm-format
      avh4-lib = self.callPackage ./elm-format/avh4-lib.nix { };
      elm-format-lib = self.callPackage ./elm-format/elm-format-lib.nix { };
      elm-format-test-lib = self.callPackage ./elm-format/elm-format-test-lib.nix { };
      elm-format-markdown = self.callPackage ./elm-format/elm-format-markdown.nix { };
    };
}
