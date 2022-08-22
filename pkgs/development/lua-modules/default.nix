# inspired by pkgs/development/haskell-modules/default.nix
{ pkgs, lib
, lua
, packagesAttr
, stdenv
, overrides ? (final: prev: {})
}:

let

  inherit (lib) extends;

  initialPackages = import ../../top-level/lua-packages.nix {
    inherit lua pkgs lib stdenv;
  };

  overridenPackages = import ./overrides.nix { inherit pkgs; };

  generatedPackages = if (builtins.pathExists ./generated-packages.nix) then
    (final: prev: pkgs.callPackage ./generated-packages.nix { inherit (final) callPackage; } final prev) else (final: prev: {});

  extensions = lib.composeManyExtensions [
    generatedPackages
    overridenPackages
    overrides
  ];

  otherSplices = let
    packagesAttrFun = set: lib.getAttrFromPath (lib.splitString "." packagesAttr) set;
  in {
    selfBuildBuild = packagesAttrFun pkgs.pkgsBuildBuild;
    selfBuildHost = packagesAttrFun pkgs.pkgsBuildHost;
    selfBuildTarget = packagesAttrFun pkgs.pkgsBuildTarget;
    selfHostHost = packagesAttrFun pkgs.pkgsHostHost;
    selfTargetTarget = if pkgs.pkgsTargetTarget.__raw or false then {} else packagesAttrFun pkgs.pkgsTargetTarget; # might be missing;
  };
  keep = self: { };
  extra = spliced0: { };

in
  lib.makeScopeWithSplicing pkgs.splicePackages pkgs.newScope otherSplices keep extra
    (lib.extends extensions initialPackages)
