{ callPackage }:

let
  # Common passthru for all perl interpreters.
  # copied from lua
  passthruFun =
    {
      overrides,
      perlOnBuildForBuild,
      perlOnBuildForHost,
      perlOnBuildForTarget,
      perlOnHostForHost,
      perlOnTargetForTarget,
      perlAttr ? null,
      self, # is perlOnHostForTarget
    }:
    let
      perlPackages =
        callPackage
          # Function that when called
          # - imports perl-packages.nix
          # - adds spliced package sets to the package set
          (
            {
              stdenv,
              pkgs,
              perl,
              callPackage,
              makeScopeWithSplicing',
            }:
            let
              perlPackagesFun = callPackage ../../../top-level/perl-packages.nix {
                inherit stdenv pkgs;
                perl = self;
              };

              otherSplices = {
                selfBuildBuild = perlOnBuildForBuild.pkgs;
                selfBuildHost = perlOnBuildForHost.pkgs;
                selfBuildTarget = perlOnBuildForTarget.pkgs;
                selfHostHost = perlOnHostForHost.pkgs;
                selfTargetTarget = perlOnTargetForTarget.pkgs or { };
              };
            in
            makeScopeWithSplicing' {
              inherit otherSplices;
              f = perlPackagesFun;
            }
          )
          {
            perl = self;
          };
    in
    rec {
      buildEnv = callPackage ./wrapper.nix {
        perl = self;
        inherit (pkgs) requiredPerlModules;
      };
      withPackages = f: buildEnv.override { extraLibs = f pkgs; };
      pkgs = perlPackages // (overrides pkgs);
      interpreter = "${self}/bin/perl";
      libPrefix = "lib/perl5/site_perl";
      perlOnBuild = perlOnBuildForHost.override {
        inherit overrides;
        self = perlOnBuild;
      };
    };

in
rec {
  # Maint version
  perl538 = callPackage ./interpreter.nix {
    self = perl538;
    version = "5.38.2";
    sha256 = "sha256-oKMVNEUet7g8fWWUpJdUOlTUiLyQygD140diV39AZV4=";
    inherit passthruFun;
  };

  # Maint version
  perl540 = callPackage ./interpreter.nix {
    self = perl540;
    version = "5.40.0";
    sha256 = "sha256-x0A0jzVzljJ6l5XT6DI7r9D+ilx4NfwcuroMyN/nFh8=";
    inherit passthruFun;
  };
}
