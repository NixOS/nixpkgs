{
  lib,
  buildLakePackage,
  fetchFromGitHub,
  batteries,
  aesop,
  Qq,
  proofwidgets,
  plausible,
  LeanSearchClient,
  importGraph,
  tests,
}:

buildLakePackage (finalAttrs: {
  pname = "lean4-mathlib";
  # nixpkgs-update: no auto update
  version = "4.29.1";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "mathlib4";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K/QPTOytsV+OX25xyKlspeB9G0a28IjmJxcUAKXFP9U=";
  };

  leanPackageName = "mathlib";
  leanDeps = [
    batteries
    aesop
    Qq
    proofwidgets
    plausible
    LeanSearchClient
    importGraph
  ];

  requiredSystemFeatures = [ "big-parallel" ];

  passthru.tests = {
    inherit (tests.lake) weak-minimax;
  };

  meta = {
    description = "Mathematical library for Lean 4";
    homepage = "https://github.com/leanprover-community/mathlib4";
    license = lib.licenses.asl20;
    # Output exceeds Hydra's 4 GiB NAR size limit. Oleans compress well with
    # zstd (~70% ratio); a squashfs-packaged output would fit, pending upstream
    # support or a raised limit.
    hydraPlatforms = [ ];
    maintainers = with lib.maintainers; [ nadja-y ];
  };
})
