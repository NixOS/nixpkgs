{
  lib,
  nix-update-script,
  fetchFromGitHub,
}:
let
  originalDrv = fetchFromGitHub {
    owner = "Aylur";
    repo = "astal";
<<<<<<< HEAD
    rev = "7d1fac8a4b2a14954843a978d2ddde86168c75ef";
    hash = "sha256-Jh4VtPcK2Ov+RTcV9FtyQRsxiJmXFQGfqX6jjM7/mgc=";
=======
    rev = "5baeb660214bcafc9ae0b733a1bc84f5fa6078f4";
    hash = "sha256-d5zsOdWeHZFP5Pc/QkgsX3UKkVDmcwY8nSJJJszMwVM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
in
originalDrv.overrideAttrs (
  final: prev: {
    name = "${final.pname}-${final.version}"; # fetchFromGitHub already defines name
    pname = "astal-source";
<<<<<<< HEAD
    version = "0-unstable-2025-11-26";
=======
    version = "0-unstable-2025-11-07";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    meta = prev.meta // {
      description = "Building blocks for creating custom desktop shells (source)";
      longDescription = ''
        Please don't use this package directly, use one of subpackages in
        `astal` namespace. This package is just a `fetchFromGitHub`, which is
        reused between all subpackages.
      '';
<<<<<<< HEAD
      maintainers = with lib.maintainers; [ PerchunPak ];
=======
      maintainers = with lib.maintainers; [ perchun ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      platforms = lib.platforms.linux;
    };

    passthru = prev.passthru // {
      updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
      src = originalDrv;
    };
  }
)
