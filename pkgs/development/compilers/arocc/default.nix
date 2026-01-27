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
      version = "0-unstable-2025-11-09";
      src = fetchFromGitHub {
        owner = "Vexu";
        repo = "arocc";
        rev = "3fb778c201718bd82bf1f08cd46ea133c4697b76";
        hash = "sha256-Hac+rhf7wB3KTs2OIfdcGVq2+H/81yXMl3cq//LUeRk=";
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
