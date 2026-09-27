{
  lib,
  buildLakePackage,
  fetchFromGitHub,
}:

buildLakePackage {
  pname = "lean4-LeanSearchClient";
  # nixpkgs-update: no auto update
  version = "4.34.0-unstable-2026-09-14";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "LeanSearchClient";
    rev = "ddf04cf3949fa556442341e87d47f9f6e6074707";
    hash = "sha256-S2dp1E3Xv9b+U+r+b/MKGHviOg7ySE8QAX7EoB6Jbl8=";
  };

  leanPackageName = "LeanSearchClient";

  meta = {
    description = "Lean 4 client for LeanSearch and Moogle proof search";
    homepage = "https://github.com/leanprover-community/LeanSearchClient";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nadja-y ];
  };
}
