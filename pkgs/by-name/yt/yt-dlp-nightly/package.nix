{
  fetchFromGitHub,
  lib,
  nix-update-script,
  yt-dlp,
}:

yt-dlp.overrideAttrs (
  finalAttrs: previousAttrs: {
    pname = "yt-dlp-nightly";
    version = "2026.07.04-unstable-2026-08-15";

    src = fetchFromGitHub {
      inherit (previousAttrs.src) owner repo;
      rev = "d2dcbfc5747190ad83093c7364491526bb724516";
      hash = "sha256-yW1Cc7y6/w9nYPrDA3rcsv5ddh6pGrIIJcCTVWQS5YM=";
    };

    postPatch = ''
      version=${lib.replaceString "-" "." finalAttrs.version}
      prefix=*unstable.
      version="''${version#$prefix}"
      python devscripts/update-version.py -c nightly -r NixOS/nixpkgs $version
    ''
    + previousAttrs.postPatch;

    passthru = previousAttrs.passthru // {
      updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
    };

    meta = previousAttrs.meta // {
      changelog = "https://github.com/yt-dlp/yt-dlp-nightly-builds/releases";
      maintainers = previousAttrs.meta.maintainers ++ (with lib.maintainers; [ RoGreat ]);
    };
  }
)
