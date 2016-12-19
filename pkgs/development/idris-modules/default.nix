{ pkgs, idris, overrides ? (self: super: {}) }: let
  inherit (pkgs.lib) callPackageWith fix' extends;

  /* Taken from haskell-modules/default.nix, should probably abstract this away */
  callPackageWithScope = scope: drv: args: (callPackageWith scope drv args) // {
    overrideScope = f: callPackageWithScope (mkScope (fix' (extends f scope.__unfix__))) drv args;
  };

  mkScope = scope : pkgs // pkgs.xorg // pkgs.gnome2 // scope;

  idrisPackages = self: let
    defaultScope = mkScope self;

    callPackage = callPackageWithScope defaultScope;

    builtins_ = pkgs.lib.mapAttrs self.build-builtin-package {
      prelude = [];

      base = [ self.prelude ];

      contrib = [ self.prelude self.base ];

      effects = [ self.prelude self.base ];

      pruviloj = [ self.prelude self.base ];
    };

    files = builtins.filter (n: n != "default") (pkgs.lib.mapAttrsToList (name: type: let
      m = builtins.match "(.*)\.nix" name;
    in if m == null then "default" else builtins.head m) (builtins.readDir ./.));
  in (builtins.listToAttrs (map (name: {
    inherit name;

    value = callPackage (./. + "/${name}.nix") {};
  }) files)) // {
    inherit idris callPackage;

    # A list of all of the libraries that come with idris
    builtins = pkgs.lib.mapAttrsToList (name: value: value) builtins_;
  } // builtins_;
in fix' (extends overrides idrisPackages)
