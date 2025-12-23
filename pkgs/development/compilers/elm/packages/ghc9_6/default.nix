{
  pkgs,
  lib,
  makeWrapper,
  nodejs,
  fetchElmDeps,
}:

self:
pkgs.haskell.packages.ghc96.override {
  overrides =
    self: super:
    let
      inherit (pkgs.haskell.lib.compose) overrideCabal;
      elmPkgs = rec {
        elm = overrideCabal (drv: {
          # sadly with parallelism most of the time breaks compilation
          enableParallelBuilding = false;
          preConfigure = fetchElmDeps {
            elmPackages = (import ../elm-srcs.nix);
            elmVersion = drv.version;
            registryDat = ../../registry.dat;
          };
          buildTools = drv.buildTools or [ ] ++ [ makeWrapper ];
          postInstall = ''
            wrapProgram $out/bin/elm \
              --prefix PATH ':' ${lib.makeBinPath [ nodejs ]}
          '';

          description = "Delightful language for reliable webapps";
          homepage = "https://elm-lang.org/";
          license = lib.licenses.bsd3;
          maintainers = with lib.maintainers; [
            turbomack
          ];
        }) (self.callPackage ./elm { });

        inherit fetchElmDeps;
        elmVersion = elmPkgs.elm.version;
      };
    in
    elmPkgs
    // {
      inherit elmPkgs;

      ansi-wl-pprint = overrideCabal (drv: {
        jailbreak = true;
      }) (self.callPackage ./ansi-wl-pprint { });
    };
}
