{ pkgs, idris-no-deps, overrides ? (self: super: {}) }: let
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

  in
    {
    inherit idris-no-deps callPackage;
    # See #10450 about why we have to wrap the executable
    idris =
        (pkgs.callPackage ./idris-wrapper.nix {})
          idris-no-deps
          { path = [ pkgs.gcc ]; lib = [pkgs.gmp]; };


    with-packages = callPackage ./with-packages.nix {} ;

    build-builtin-package = callPackage ./build-builtin-package.nix {};

    build-idris-package = callPackage ./build-idris-package.nix {};

    # Libraries

    # A list of all of the libraries that come with idris
    builtins = pkgs.lib.mapAttrsToList (name: value: value) builtins_;

    httpclient = callPackage ./httpclient.nix {};

    lightyear = callPackage ./lightyear.nix {};

    wl-pprint = callPackage ./wl-pprint.nix {};

    specdris = callPackage ./specdris.nix {};


  } // builtins_;
in fix' (extends overrides idrisPackages)
