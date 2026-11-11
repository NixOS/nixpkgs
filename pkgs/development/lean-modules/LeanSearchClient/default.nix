{
  lib,
  buildLakePackage,
  fetchFromGitHub,
}:

buildLakePackage {
  pname = "lean4-LeanSearchClient";
  # nixpkgs-update: no auto update
  version = "4.35.0-unstable-2026-10-12";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "LeanSearchClient";
    rev = "d6b4c7be5be75ec4917c873ac50c756dc1436372";
    hash = "sha256-Yp3i1ygUXANiA1sRJc54QdjXeospB4IbGEeioY5x7ec=";
  };

  leanPackageName = "LeanSearchClient";

  meta = {
    description = "Lean 4 client for LeanSearch and Moogle proof search";
    homepage = "https://github.com/leanprover-community/LeanSearchClient";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nadja-y ];
  };
}
