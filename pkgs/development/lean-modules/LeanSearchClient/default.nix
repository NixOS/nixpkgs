{
  lib,
  buildLakePackage,
  fetchFromGitHub,
}:

buildLakePackage {
  pname = "lean4-LeanSearchClient";
  # nixpkgs-update: no auto update
  version = "4.33.0-unstable-2026-08-10";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "LeanSearchClient";
    rev = "5f4d51b81cbd3f6b32b156bfad9056621a040404";
    hash = "sha256-3/60K6ADnAhI0RxnCZSKQKLiaByTI/cV3lUbJND7noE=";
  };

  leanPackageName = "LeanSearchClient";

  meta = {
    description = "Lean 4 client for LeanSearch and Moogle proof search";
    homepage = "https://github.com/leanprover-community/LeanSearchClient";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nadja-y ];
  };
}
