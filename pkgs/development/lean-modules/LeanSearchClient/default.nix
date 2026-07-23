{
  lib,
  buildLakePackage,
  fetchFromGitHub,
}:

buildLakePackage {
  pname = "lean4-LeanSearchClient";
  # No lockstep tags; version pinned by mathlib's lake-manifest.json.
  version = "0-unstable-2026-02-12";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "LeanSearchClient";
    rev = "c5d5b8fe6e5158def25cd28eb94e4141ad97c843";
    hash = "sha256-L2aAwn3OeRLVt/VccLdBS0ogqmIIKAwnz94PpAOhaRc=";
  };

  leanPackageName = "LeanSearchClient";

  meta = {
    description = "Lean 4 client for LeanSearch and Moogle proof search";
    homepage = "https://github.com/leanprover-community/LeanSearchClient";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nadja-y ];
  };
}
