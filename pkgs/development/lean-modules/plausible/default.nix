{
  lib,
  buildLakePackage,
  fetchFromGitHub,
}:

buildLakePackage {
  pname = "lean4-plausible";
  # nixpkgs-update: no auto update
  version = "4.30.0-unstable-2026-05-26";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "plausible";
    rev = "a456461b368b71d2accd95234832cd9c174b5437";
    hash = "sha256-DSaS0W2cfCUh2N+7WyiM7aUv3trtRNON0PzCgCW2SKY=";
  };

  leanPackageName = "plausible";

  meta = {
    description = "Property-based testing framework for Lean 4";
    homepage = "https://github.com/leanprover-community/plausible";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nadja-y ];
  };
}
