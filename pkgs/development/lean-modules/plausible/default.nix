{
  lib,
  buildLakePackage,
  fetchFromGitHub,
}:

buildLakePackage {
  pname = "lean4-plausible";
  # nixpkgs-update: no auto update
  version = "4.35.0-unstable-2026-10-12";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "plausible";
    rev = "dfa4f38190d07c37e315953e08b90fe2d95b3c24";
    hash = "sha256-xm+PPwM8a58hV/Wo3mzG6Lcb4P+OXJy9SBteTavorqg=";
  };

  leanPackageName = "plausible";

  meta = {
    description = "Property-based testing framework for Lean 4";
    homepage = "https://github.com/leanprover-community/plausible";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nadja-y ];
  };
}
