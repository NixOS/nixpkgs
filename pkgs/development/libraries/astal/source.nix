{
  lib,
  nix-update-script,
  fetchFromGitHub,
}:
(fetchFromGitHub {
  owner = "Aylur";
  repo = "astal";
  rev = "cac0fc63bfe098b26753db8262f5d95ac42b281b";
  hash = "sha256-kNtKWbQ+gMzmAF7KNSZ4Hb8/2cfSNoURCyRSB0nx2I4=";
}).overrideAttrs
  (old: rec {
    name = "${pname}-${version}"; # fetchFromGitHub already defines name
    pname = "astal-source";
    version = "0-unstable-2025-01-13";

    meta = old.meta // {
      description = "Building blocks for creating custom desktop shells (source)";
      longDescription = ''
        Please don't use this package directly, use one of subpackages in
        `astal` namespace. This package is just a `fetchFromGitHub`, which is
        reused between all subpackages.
      '';
      maintainers = with lib.maintainers; [ perchun ];
    };

    passthru = old.passthru // {
      updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
    };
  })
