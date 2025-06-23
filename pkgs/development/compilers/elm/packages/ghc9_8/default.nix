{ pkgs, lib }:

self:
pkgs.haskell.packages.ghc98.override {
  overrides =
    self: super:
    let
      inherit (pkgs.haskell.lib.compose) justStaticExecutables overrideCabal;

      elmPkgs = {
        /*
          The elm-format expression is updated via a script in the https://github.com/avh4/elm-format repo:
          `package/nix/build.sh`
        */
        elm-format = justStaticExecutables (
          overrideCabal (drv: {
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
