{ callPackage }:

let
  # Common passthru for all perl interpreters.
  # copied from lua
  passthruFun =
    { overrides
    , perlOnBuildForBuild
    , perlOnBuildForHost
    , perlOnBuildForTarget
    , perlOnHostForHost
    , perlOnTargetForTarget
    , perlAttr ? null
    , self # is perlOnHostForTarget
    }: let
      perlPackages = callPackage
        # Function that when called
        # - imports perl-packages.nix
        # - adds spliced package sets to the package set
        ({ stdenv, pkgs, perl, callPackage, makeScopeWithSplicing' }: let
          perlPackagesFun = callPackage ../../../top-level/perl-packages.nix {
            # allow 'perlPackages.override { pkgs = pkgs // { imagemagick = imagemagickBig; }; }' like in python3Packages
            # most perl packages aren't called with callPackage so it's not possible to override their arguments individually
            # the conditional is because the // above won't be applied to __splicedPackages and hopefully no one is doing that when cross-compiling
            pkgs = if stdenv.buildPlatform != stdenv.hostPlatform then pkgs.__splicedPackages else pkgs;
            inherit stdenv;
            perl = self;
          };

          otherSplices = {
            selfBuildBuild = perlOnBuildForBuild.pkgs;
            selfBuildHost = perlOnBuildForHost.pkgs;
            selfBuildTarget = perlOnBuildForTarget.pkgs;
            selfHostHost = perlOnHostForHost.pkgs;
            selfTargetTarget = perlOnTargetForTarget.pkgs or {};
          };
        in makeScopeWithSplicing' {
          inherit otherSplices;
          f = perlPackagesFun;
        })
        {
          perl = self;
        };
    in rec {
        buildEnv = callPackage ./wrapper.nix {
          perl = self;
          inherit (pkgs) requiredPerlModules;
        };
        withPackages = f: buildEnv.override { extraLibs = f pkgs; };
        pkgs = perlPackages // (overrides pkgs);
        interpreter = "${self}/bin/perl";
        libPrefix = "lib/perl5/site_perl";
        perlOnBuild = perlOnBuildForHost.override { inherit overrides; self = perlOnBuild; };
  };

in rec {
  # Maint version
  perl538 = callPackage ./interpreter.nix {
    self = perl538;
    version = "5.38.3";
    sha256 = "sha256-ioAzhZ3R116wyRWO7dc4TfGva0aipOhQc7B+bMfFuHM=";
    inherit passthruFun;
  };

  # Maint version
  perl540 = callPackage ./interpreter.nix {
    self = perl540;
    version = "5.40.1";
    sha256 = "sha256-AvjEW7N57Qw951FPrUjHFP1Gvo8LU2v9UyAFAWWh7iY=";
    inherit passthruFun;
  };
}
