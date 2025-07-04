{
  lib,
  nix-update-script,
  fetchFromGitHub,
}:
let
  originalDrv = fetchFromGitHub {
    owner = "Aylur";
    repo = "astal";
    rev = "4820a3e37cc8eb81db6ed991528fb23472a8e4de";
    hash = "sha256-SaHAtzUyfm4urAcUEZlBFn7dWhoDqA6kaeFZ11CCTf8=";
  };
in
originalDrv.overrideAttrs (
  final: prev: {
    name = "${final.pname}-${final.version}"; # fetchFromGitHub already defines name
    pname = "astal-source";
    version = "0-unstable-2025-05-12";

    meta = prev.meta // {
      description = "Building blocks for creating custom desktop shells (source)";
      longDescription = ''
        Please don't use this package directly, use one of subpackages in
        `astal` namespace. This package is just a `fetchFromGitHub`, which is
        reused between all subpackages.
      '';
      maintainers = with lib.maintainers; [ perchun ];
      platforms = lib.platforms.linux;
    };

    passthru = prev.passthru // {
      updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
      src = originalDrv;
    };
  }
)
