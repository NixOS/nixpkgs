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
  # We are removing `meta.knownVulnerabilities` from `python27`,
  # and setting it in `resholve` itself.
  python27' = (removeKnownVulnerabilities pkgsBuildHost.python27).override {
    self = python27';
    pkgsBuildHost = pkgsBuildHost // {
      python27 = python27';
    };
    # strip down that python version as much as possible
    openssl = null;
    bzip2 = null;
    readline = null;
    ncurses = null;
    gdbm = null;
    sqlite = null;
    rebuildBytecode = false;
    stripBytecode = true;
    strip2to3 = true;
    stripConfig = true;
    stripIdlelib = true;
    stripTests = true;
    enableOptimizations = false;
  };
  callPackage = lib.callPackageWith (pkgsBuildHost // { python27 = python27'; });
  source = callPackage ./source.nix { };
  deps = callPackage ./deps.nix { };
  # not exposed in all-packages
  resholveBuildTimeOnly = removeKnownVulnerabilities resholve;
in
rec {
  # resholve itself
  resholve = (
    callPackage ./resholve.nix {
      inherit (source) rSrc version;
      inherit (deps.oil) oildev;
      inherit (deps) configargparse;
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
