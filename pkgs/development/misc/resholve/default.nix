{ lib
, pkgs
, pkgsBuildHost
, ...
}:

let
  python27' = (pkgsBuildHost.python27.overrideAttrs (old:
    {
      # Overriding `meta.knownVulnerabilities` here, see #201859 for why it exists
      # In resholve case this should not be a security issue,
      # since it will only be used during build, not runtime
      meta = (old.meta or { }) // { knownVulnerabilities = [ ]; };
    }
  )).override {
    self = python27';
    pkgsBuildHost = pkgsBuildHost // { python27 = python27'; };
    # strip down that python version as much as possible
    openssl = null;
    bzip2 = null;
    readline = null;
    ncurses = null;
    gdbm = null;
    sqlite = null;
    libffi = null;
    rebuildBytecode = false;
    stripBytecode = true;
    strip2to3 = true;
    stripConfig = true;
    stripIdlelib = true;
    stripTests = true;
    enableOptimizations = false;
  };
  callPackage = lib.callPackageWith (pkgs // { python27 = python27'; });
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
