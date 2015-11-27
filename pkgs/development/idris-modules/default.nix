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
  in {
    withPackages = packages: callPackage ./with-packages-wrapper.nix { inherit packages idris; };
  };
in fix' (extends overrides idrisPackages)
