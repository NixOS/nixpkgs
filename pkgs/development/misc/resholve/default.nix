{ lib
, stdenv
, pkgsBuildHost
, ...
}:

let
  pkgs = import ../../../.. {
    inherit (stdenv.hostPlatform) system;
    # Allow python27 with known security issues only for resholve,
    # see issue #201859 for the reasoning
    # In resholve case this should not be a security issue,
    # since it will only be used during build, not runtime
    config.permittedInsecurePackages = [ pkgsBuildHost.python27.name ];
  };
  callPackage = lib.callPackageWith pkgs;
  source = callPackage ./source.nix { };
  deps = callPackage ./deps.nix { };
in
rec {
  # resholve itself
  resholve = callPackage ./resholve.nix {
    inherit (source) rSrc version;
    inherit (deps.oil) oildev;
    inherit (deps) configargparse;
    inherit resholve-utils;
  };
  # funcs to validate and phrase invocations of resholve
  # and use those invocations to build packages
  resholve-utils = callPackage ./resholve-utils.nix {
    inherit resholve;
  };
}
