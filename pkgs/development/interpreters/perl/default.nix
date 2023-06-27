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
        ({ stdenv, pkgs, perl, callPackage, makeScopeWithSplicing }: let
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
          keep = self: { };
          extra = spliced0: {};
        in makeScopeWithSplicing
          otherSplices
          keep
          extra
          perlPackagesFun)
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
  perl534 = callPackage ./intepreter.nix {
    self = perl534;
    version = "5.34.1";
    sha256 = "sha256-NXlRpJGwuhzjYRJjki/ux4zNWB3dwkpEawM+JazyQqE=";
    inherit passthruFun;
  };

  # Maint version
  perl536 = callPackage ./intepreter.nix {
    self = perl536;
    version = "5.36.0";
    sha256 = "sha256-4mCFr4rDlvYq3YpTPDoOqMhJfYNvBok0esWr17ek4Ao=";
    inherit passthruFun;
  };

  # the latest Devel version
  perldevel = callPackage ./intepreter.nix {
    self = perldevel;
    perlAttr = "perldevel";
    version = "5.37.0";
    sha256 = "sha256-8RQO6gtH+WmghqzRafbqAH1MhKv/vJCcvysi7/+T9XI=";
    inherit passthruFun;
  };
}
