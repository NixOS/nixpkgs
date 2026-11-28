{
  lib,
  stdenv,
  callPackage,
  pythonPackagesExtensions,
  config,
  makeScopeWithSplicing',
  ...
}:

let
  inherit (lib)
    attrByPath
    composeExtensions
    composeManyExtensions
    elem
    extends
    hasInfix
    isDerivation
    mapAttrs
    optionalAttrs
    optionals
    substring
    versionAtLeast
    versionOlder
    ;
in
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
let
  pythonPackages =
    let
      # TODO: only run these checks in CI, since they now pass for every package
      ensurePythonModules =
        items:
        let
          inherit (pythonPackages) hasPythonModule;
          providesSetupHook = attrByPath [ "provides" "setupHook" ] false;
          exceptions = [
            stdenv
          ];
          func =
            name: value:
            if isDerivation value then
              assert
                hasPythonModule value
                || providesSetupHook value
                || elem value exceptions
                || throw "${name} should use `buildPythonPackage` or `toPythonModule` if it is to be part of the Python packages set.";
              value
            else
              value;
        in
        mapAttrs func items;
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
            optionalExtensions = cond: as: optionals cond as;
            pythonExtension = import ../../../top-level/python-packages.nix;
            python2Extension = import ../../misc/resholve/python2-packages.nix;
            extensions = composeManyExtensions (
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
              optionalAttrs config.allowAliases (import ../../../top-level/python-aliases.nix lib self super);
          in
          makeScopeWithSplicing' {
            inherit otherSplices keep;
            f = extends (composeExtensions aliases extensions) pythonPackagesFun;
          }
        )
        {
          overrides = packageOverrides;
          python = self;
        }
    );
in
rec {
  isPy311 = pythonVersion == "3.11";
  isPy312 = pythonVersion == "3.12";
  isPy313 = pythonVersion == "3.13";
  isPy314 = pythonVersion == "3.14";
  isPy3 = substring 0 1 pythonVersion == "3";
  isPy3k = isPy3;
  isPyPy = hasInfix "pypy" interpreter;

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
    isFreeThreaded
    libPrefix
    pythonVersion
    sitePackages
    ;
  inherit sourceVersion;
  pythonAtLeast = versionAtLeast pythonVersion;
  pythonOlder = versionOlder pythonVersion;
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
