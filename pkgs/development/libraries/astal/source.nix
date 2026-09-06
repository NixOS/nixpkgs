{
  lib,
  nix-update-script,
  fetchFromGitHub,
}:
let
  originalDrv = fetchFromGitHub {
    owner = "Aylur";
    repo = "astal";
    rev = "82f3964d19e39904e32807d3e452a2e19b0493ef";
    hash = "sha256-EPYOE7qZ5oxT8IR7qC3cUvlJz9ULuhjMmtA0anVVxH8=";
  };
in
originalDrv.overrideAttrs (
  final: prev: {
    name = "${final.pname}-${final.version}"; # fetchFromGitHub already defines name
    pname = "astal-source";
    version = "0-unstable-2026-08-30";

    meta = prev.meta // {
      description = "Building blocks for creating custom desktop shells (source)";
      longDescription = ''
        Please don't use this package directly, use one of subpackages in
        `astal` namespace. This package is just a `fetchFromGitHub`, which is
        reused between all subpackages.
      '';
      maintainers = with lib.maintainers; [ PerchunPak ];
      platforms = lib.platforms.linux;
    };

    passthru = prev.passthru // {
      updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
      src = originalDrv;
    };
  }
)
