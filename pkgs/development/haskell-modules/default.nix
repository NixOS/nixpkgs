{ pkgs, stdenv, ghc
, packageSetConfig ? (self: super: {})
, overrides ? (self: super: {})
}:

with ./lib.nix;

let

  fix = f: let x = f x // { __unfix__ = f; }; in x;

  extend = rattrs: f: self: let super = rattrs self; in super // f self super;

  haskellPackages = self:
    let

      mkDerivation = pkgs.callPackage ./generic-builder.nix {
        inherit stdenv;
        inherit (pkgs) fetchurl pkgconfig glibcLocales coreutils gnugrep gnused;
        inherit (self) ghc jailbreak-cabal;
        hscolour = overrideCabal self.hscolour (drv: {
          isLibrary = false;
          doHaddock = false;
          hyperlinkSource = false;      # Avoid depending on hscolour for this build.
          postFixup = "rm -rf $out/lib $out/share $out/nix-support";
        });
        cpphs = overrideCabal (self.cpphs.overrideScope (self: super: {
          mkDerivation = drv: super.mkDerivation (drv // {
            enableSharedExecutables = false;
            enableSharedLibraries = false;
            doHaddock = false;
            useCpphs = false;
          });
        })) (drv: {
            isLibrary = false;
            postFixup = "rm -rf $out/lib $out/share $out/nix-support";
        });
      };

      overrideCabal = drv: f: drv.override (args: args // {
        mkDerivation = drv: args.mkDerivation (drv // f drv);
      });

      callPackageWithScope = scope: drv: args: (stdenv.lib.callPackageWith scope drv args) // {
        overrideScope = f: callPackageWithScope (mkScope (fix (extend scope.__unfix__ f))) drv args;
      };

      mkScope = scope: pkgs // pkgs.xlibs // pkgs.gnome // scope;
      defaultScope = mkScope self;
      callPackage = drv: args: callPackageWithScope defaultScope drv args;

    in
      import ./hackage-packages.nix { inherit pkgs stdenv callPackage; } self // {

        inherit mkDerivation callPackage;

        ghcWithPackages = pkgs: callPackage ./with-packages-wrapper.nix {
          inherit (self) llvmPackages;
          haskellPackages = self;
          packages = pkgs self;
        };

        ghc = ghc // { withPackages = self.ghcWithPackages; };

      };

  commonConfiguration = import ./configuration-common.nix { inherit pkgs; };

in

  fix (extend (extend (extend haskellPackages commonConfiguration) packageSetConfig) overrides)
