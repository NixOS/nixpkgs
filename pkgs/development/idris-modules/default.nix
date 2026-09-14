{
  pkgs,
  config,
  idris-no-deps,
  overrides ? (self: super: { }),
}:
let
  inherit (pkgs.lib) callPackageWith fix' extends;

  # Taken from haskell-modules/default.nix, should probably abstract this away
  callPackageWithScope =
    scope: drv: args:
    (callPackageWith scope drv args)
    // {
      overrideScope = f: callPackageWithScope (mkScope (fix' (extends f scope.__unfix__))) drv args;
    };

  mkScope = scope: pkgs // scope;

  idrisPackages =
    self:
    let
      defaultScope = mkScope self;

      callPackage = callPackageWithScope defaultScope;

      builtins_ = pkgs.lib.mapAttrs self.build-builtin-package {
        prelude = [ ];

        base = [ self.prelude ];

        contrib = [
          self.prelude
          self.base
        ];

        effects = [
          self.prelude
          self.base
        ];

        pruviloj = [
          self.prelude
          self.base
        ];
      };

    in
    {
      inherit idris-no-deps callPackage;

      # Idris wrapper with specified compiler and library paths, used to build packages

      idris = pkgs.callPackage ./idris-wrapper.nix {
        inherit idris-no-deps;
      };

      # Utilities for building packages

      with-packages = callPackage ./with-packages.nix { };

      build-builtin-package = callPackage ./build-builtin-package.nix { };

      build-idris-package = callPackage ./build-idris-package.nix { };

      # The set of libraries that comes with idris

      builtins = pkgs.lib.attrValues builtins_;

      # Libraries

      quantities = callPackage ./quantities.nix { };

      specdris = callPackage ./specdris.nix { };

      tf-random = callPackage ./tfrandom.nix { };

      wl-pprint = callPackage ./wl-pprint.nix { };
    }
    // builtins_
    // pkgs.lib.optionalAttrs config.allowAliases {
      # removed packages
      descncrunch = throw "descncrunch has been removed because it has been marked as broken since 2018."; # Added 2025-10-11
      protobuf = throw "idrisPackages.protobuf has been removed: abandoned by upstream"; # Added 2022-02-06
      sdl = throw "'idrisPackages.sdl' has been removed, as it was broken and unmaintained"; # added 2024-05-09
    };
in
fix' (extends overrides idrisPackages)
