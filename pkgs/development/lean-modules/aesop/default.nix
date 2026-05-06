{
  lib,
  buildLakePackage,
  fetchFromGitHub,
  batteries,
}:

buildLakePackage {
  pname = "lean4-aesop";
  # nixpkgs-update: no auto update
  version = "4.29.0-unstable-2026-03-28";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "aesop";
    rev = "7152850e7b216a0d409701617721b6e469d34bf6";
    hash = "sha256-CNwxNig8OWjtfQRYyRnM/HGBn2oaNX5qP9CVT2eWNlg=";
  };

  leanPackageName = "aesop";
  leanDeps = [ batteries ];

  meta = {
    description = "White-box automation for Lean 4";
    homepage = "https://github.com/leanprover-community/aesop";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nadja-y ];
  };
}
