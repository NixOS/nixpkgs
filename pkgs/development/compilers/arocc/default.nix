{
  lib,
  fetchFromGitHub,
  callPackage,
  zig,
}:
let
  versions = [
    {
      inherit zig;
      version = "0-unstable-2026-04-02";
      src = fetchFromGitHub {
        owner = "Vexu";
        repo = "arocc";
        rev = "5f5a050569a95ecc40a426f0c3666ae7ef987ede";
        hash = "sha256-f8Z0SXWx5Uia2TCMB5SUpcO8+xUnaWk32Oknva7xcxw=";
      };
    }
  ];

  mkPackage =
    {
      zig,
      version,
      src,
    }:
    callPackage ./package.nix { inherit zig version src; };

  pkgsList = lib.map mkPackage versions;

  pkgsAttrsUnwrapped = lib.listToAttrs (
    lib.map (pkg: lib.nameValuePair "${pkg.version}-unwrapped" pkg) pkgsList
  );
  pkgsAttrsWrapped = lib.listToAttrs (
    lib.map (pkg: lib.nameValuePair pkg.version pkg.wrapped) pkgsList
  );

  pkgsAttrs = pkgsAttrsWrapped // pkgsAttrsUnwrapped;
in
{
  latest-unwrapped = lib.last pkgsList;
  latest = (lib.last pkgsList).wrapped;
}
// pkgsAttrs
