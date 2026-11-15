{
  lib,
  buildLakePackage,
  fetchFromGitHub,
}:

buildLakePackage {
  pname = "lean4-LeanSearchClient";
  # nixpkgs-update: no auto update
  version = "4.36.0-unstable-2026-11-16";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "LeanSearchClient";
    rev = "4fb58e749ef3fc0395fe274f6cab70c2ea85f1c9";
    hash = "sha256-ubo1aO48YAkqnj5unV/ioxtQzUoAQsCkRwCrpnfWxNw=";
  };

  leanPackageName = "LeanSearchClient";

  meta = {
    description = "Lean 4 client for LeanSearch and Moogle proof search";
    homepage = "https://github.com/leanprover-community/LeanSearchClient";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nadja-y ];
  };
}
