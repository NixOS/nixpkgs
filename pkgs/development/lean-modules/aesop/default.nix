{
  lib,
  buildLakePackage,
  fetchFromGitHub,
  batteries,
}:

buildLakePackage {
  pname = "lean4-aesop";
  # nixpkgs-update: no auto update
  version = "4.31.0-unstable-2026-06-15";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "aesop";
    rev = "e3cb2f741431ce31bf73549fb52316a57368b06f";
    hash = "sha256-g/dxj2uPYoZBxoR9fH0Hco8V0fF5gLJoxD9lt1YUE/Q=";
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
