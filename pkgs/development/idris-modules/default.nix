{ pkgs, idris, overrides ? (self: super: {}) }: let
  inherit (pkgs.lib) callPackageWith fix' extends;

  /* Taken from haskell-modules/default.nix, should probably abstract this away */
  callPackageWithScope = scope: drv: args: (callPackageWith scope drv args) // {
    overrideScope = f: callPackageWithScope (mkScope (fix' (extends f scope.__unfix__))) drv args;
  };

  mkScope = scope : pkgs // pkgs.xorg // pkgs.gnome // scope;

  idrisPackages = self: let
    defaultScope = mkScope self;

    callPackage = callPackageWithScope defaultScope;

    buildBuiltinPackage = callPackage ./build-builtin-package.nix {};

    builtins = pkgs.lib.mapAttrs buildBuiltinPackage {
      prelude = [];

      base = [ self.prelude ];

      contrib = [ self.prelude self.base ];

      effects = [ self.prelude self.base ];

      pruviloj = [ self.prelude self.base ];
    };
  in {
    inherit idris;

    withPackages = callPackage ./with-packages-wrapper.nix {};

    buildIdrisPackage = callPackage ./build-idris-package.nix {};

    builtins = pkgs.lib.mapAttrsToList (name: value: value) builtins;
  } // builtins;
in fix' (extends overrides idrisPackages)
