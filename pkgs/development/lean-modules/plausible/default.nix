{
  lib,
  buildLakePackage,
  fetchFromGitHub,
}:

buildLakePackage {
  pname = "lean4-plausible";
  # nixpkgs-update: no auto update
  version = "4.31.0-unstable-2026-06-15";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "plausible";
    rev = "63045536fe95024e6c18fc7b48e03f506701c5bc";
    hash = "sha256-jajg1nEPO0OaiTNYoR31302YKdD1E2Y+ZmyohmKaAHI=";
  };

  leanPackageName = "plausible";

  meta = {
    description = "Property-based testing framework for Lean 4";
    homepage = "https://github.com/leanprover-community/plausible";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nadja-y ];
  };
}
