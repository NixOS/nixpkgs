{
  lib,
  pkgsBuildHost,
  resholve,
}:

let
  removeKnownVulnerabilities =
    pkg:
    pkg.overrideAttrs (old: {
      meta = (old.meta or { }) // {
        knownVulnerabilities = [ ];
      };
    });
  callPackage = lib.callPackageWith pkgsBuildHost;
  source = callPackage ./source.nix { };
  # not exposed in all-packages
  resholveBuildTimeOnly = removeKnownVulnerabilities resholve;
in
rec {
  # resholve itself
  resholve = (
    callPackage ./resholve.nix {
      inherit (source) rSrc version;
      inherit resholve-utils;
      # used only in tests
      resholve = resholveBuildTimeOnly;
    }
  );
  # funcs to validate and phrase invocations of resholve
  # and use those invocations to build packages
  resholve-utils = callPackage ./resholve-utils.nix {
    # we can still use resholve-utils without triggering a security warn
    # this is safe since we will only use `resholve` at build time
    resholve = resholveBuildTimeOnly;
  };
}
