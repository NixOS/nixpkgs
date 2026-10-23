{
  lib,
  buildLakePackage,
  fetchFromGitHub,
  batteries,
}:

buildLakePackage {
  pname = "lean4-aesop";
  # nixpkgs-update: no auto update
  version = "4.35.0-unstable-2026-10-12";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "aesop";
    rev = "4a174c490d8707121c4a9290800489f105d85e07";
    hash = "sha256-ZKoq/n59JAt7TJgb4yVFsiMdIvqTlGuuz/TnU95NMdA=";
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
