{
  lib,
  callPackage,
  python3PackagesFor,
  ...
}:

{
  implementation,
  libPrefix,
  executable,
  sourceVersion,
  pythonVersion,
  packageOverrides,
  sitePackages,
  hasDistutilsCxxPatch,
  pythonOnBuildForBuild,
  pythonOnBuildForHost,
  pythonOnBuildForTarget,
  pythonOnHostForHost,
  pythonOnTargetForTarget,
  pythonAttr ? null,
  pythonABITags ? [ "none" ],
  isFreeThreaded ? false,
  self, # is pythonOnHostForTarget
}:
rec {
  isPy311 = pythonVersion == "3.11";
  isPy312 = pythonVersion == "3.12";
  isPy313 = pythonVersion == "3.13";
  isPy314 = pythonVersion == "3.14";
  isPy3 = lib.strings.substring 0 1 pythonVersion == "3";
  isPy3k = isPy3;
  isPyPy = lib.hasInfix "pypy" interpreter;

  buildEnv = callPackage ./wrapper.nix {
    python = self;
    inherit (pkgs) requiredPythonModules;
  };
  withPackages = import ./with-packages.nix {
    inherit buildEnv;
    pythonPackages = pkgs;
  };
  pkgs = python3PackagesFor self packageOverrides;
  interpreter = "${self}/bin/${executable}";
  inherit
    executable
    implementation
    isFreeThreaded
    libPrefix
    pythonVersion
    sitePackages
    ;
  inherit sourceVersion;
  pythonAtLeast = lib.versionAtLeast pythonVersion;
  pythonOlder = lib.versionOlder pythonVersion;
  inherit hasDistutilsCxxPatch;
  inherit
    pythonOnBuildForBuild
    pythonOnBuildForHost
    pythonOnBuildForTarget
    pythonOnHostForHost
    pythonOnTargetForTarget
    ;
  inherit pythonABITags;

  tests = callPackage ./tests.nix {
    python = self;
  };

  inherit pythonAttr;
}
