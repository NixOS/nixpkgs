{
  lib,
  stdenv,
  callPackage,
  pythonPackagesExtensions,
  config,
  makeScopeWithSplicing',
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
  self, # is pythonOnHostForTarget
}:
let
  pythonPackages =
    let
      ensurePythonModules =
        items:
        let
          exceptions = [
            stdenv
          ];
          providesSetupHook = lib.attrByPath [ "provides" "setupHook" ] false;
          valid =
            value: pythonPackages.hasPythonModule value || providesSetupHook value || lib.elem value exceptions;
          func =
            name: value:
            if lib.isDerivation value then
              lib.extendDerivation (
                valid value
                || throw "${name} should use `buildPythonPackage` or `toPythonModule` if it is to be part of the Python packages set."
              ) { } value
            else
              value;
        in
        lib.mapAttrs func items;
    in
    ensurePythonModules (
      callPackage
        # Function that when called
        # - imports python-packages.nix
        # - adds spliced package sets to the package set
        # - applies overrides from `packageOverrides` and `pythonPackagesOverlays`.
        (
          {
            pkgs,
            stdenv,
            python,
            overrides,
          }:
          let
            pythonPackagesFun = import ./python-packages-base.nix {
              inherit stdenv pkgs lib;
              python = self;
            };
            otherSplices = {
              selfBuildBuild = pythonOnBuildForBuild.pkgs;
              selfBuildHost = pythonOnBuildForHost.pkgs;
              selfBuildTarget = pythonOnBuildForTarget.pkgs;
              selfHostHost = pythonOnHostForHost.pkgs;
              selfTargetTarget = pythonOnTargetForTarget.pkgs or { }; # There is no Python TargetTarget.
            };
            hooks = import ./hooks/default.nix;
            keep = self: hooks self { };
            optionalExtensions = cond: as: lib.optionals cond as;
            pythonExtension = import ../../../top-level/python-packages.nix;
            python2Extension = import ../../../top-level/python2-packages.nix;
            extensions = lib.composeManyExtensions (
              [
                hooks
                pythonExtension
              ]
              ++ (optionalExtensions (!self.isPy3k) [
                python2Extension
              ])
              ++ pythonPackagesExtensions
              ++ [
                overrides
              ]
            );
            aliases =
              self: super:
              lib.optionalAttrs config.allowAliases (import ../../../top-level/python-aliases.nix lib self super);
          in
          makeScopeWithSplicing' {
            inherit otherSplices keep;
            f = lib.extends (lib.composeExtensions aliases extensions) pythonPackagesFun;
          }
        )
        {
          overrides = packageOverrides;
          python = self;
        }
    );
  pythonOnBuildForHost_overridden = pythonOnBuildForHost.override {
    inherit packageOverrides;
    self = pythonOnBuildForHost_overridden;
  };
in
rec {
  isPy27 = pythonVersion == "2.7";
  isPy37 = pythonVersion == "3.7";
  isPy38 = pythonVersion == "3.8";
  isPy39 = pythonVersion == "3.9";
  isPy310 = pythonVersion == "3.10";
  isPy311 = pythonVersion == "3.11";
  isPy312 = pythonVersion == "3.12";
  isPy2 = lib.strings.substring 0 1 pythonVersion == "2";
  isPy3 = lib.strings.substring 0 1 pythonVersion == "3";
  isPy3k = isPy3;
  isPyPy = lib.hasInfix "pypy" interpreter;

  buildEnv = callPackage ./wrapper.nix {
    python = self;
    inherit (pythonPackages) requiredPythonModules;
  };
  withPackages = import ./with-packages.nix { inherit buildEnv pythonPackages; };
  pkgs = pythonPackages;
  interpreter = "${self}/bin/${executable}";
  inherit
    executable
    implementation
    libPrefix
    pythonVersion
    sitePackages
    ;
  inherit sourceVersion;
  pythonAtLeast = lib.versionAtLeast pythonVersion;
  pythonOlder = lib.versionOlder pythonVersion;
  inherit hasDistutilsCxxPatch;
  # Remove after 24.11 is released.
  pythonForBuild =
    lib.warnIf (lib.oldestSupportedReleaseIsAtLeast 2311)
      "`pythonForBuild` (from `python*`) has been renamed to `pythonOnBuildForHost`"
      pythonOnBuildForHost_overridden;
  pythonOnBuildForHost = pythonOnBuildForHost_overridden;

  tests = callPackage ./tests.nix {
    python = self;
  };

  inherit pythonAttr;
}
