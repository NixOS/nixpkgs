{
  lib,
  buildLakePackage,
  fetchFromGitHub,
  batteries,
}:

buildLakePackage {
  pname = "lean4-aesop";
  # nixpkgs-update: no auto update
  version = "4.34.0-unstable-2026-09-14";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "aesop";
    rev = "355695d523e41d0554926416cba2a2b3544fbbc9";
    hash = "sha256-yF2+P7H0B3546zopncnH2APEynRRJjTy+17OEAFovkE=";
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
