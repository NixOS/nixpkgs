{
  lib,
  nix-update-script,
  fetchFromGitHub,
}:
let
  originalDrv = fetchFromGitHub {
    owner = "Aylur";
    repo = "astal";
    rev = "12c15b44608422e494c387aba6adc1ab6315d925";
    hash = "sha256-EfTrJse33t3RP//DqESkTMCpMSdIi/wxxfa12+eP5jo=";
  };
in
originalDrv.overrideAttrs (
  final: prev: {
    name = "${final.pname}-${final.version}"; # fetchFromGitHub already defines name
    pname = "astal-source";
    version = "0-unstable-2025-10-05";

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
