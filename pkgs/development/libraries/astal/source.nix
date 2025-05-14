{
  lib,
  nix-update-script,
  fetchFromGitHub,
}:
(fetchFromGitHub {
  owner = "Aylur";
  repo = "astal";
  rev = "dc0e5d37abe9424c53dcbd2506a4886ffee6296e";
  hash = "sha256-5WgfJAeBpxiKbTR/gJvxrGYfqQRge5aUDcGKmU1YZ1Q=";
}).overrideAttrs
  (
    final: prev: {
      name = "${final.pname}-${final.version}"; # fetchFromGitHub already defines name
      pname = "astal-source";
      version = "0-unstable-2025-03-21";

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
      };
    }
  )
