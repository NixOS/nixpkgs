{
  lib,
  buildLakePackage,
  fetchFromGitHub,
}:

buildLakePackage {
  pname = "lean4-plausible";
  # nixpkgs-update: no auto update
  version = "4.34.0-unstable-2026-09-14";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "plausible";
    rev = "118aa17ee84656b8bd727fef7c458ee8c833385c";
    hash = "sha256-/ianaKsruF30J5tqK4vtbXsFd3mu4Xt8Ppj4ibHDEvg=";
  };

  leanPackageName = "plausible";

  meta = {
    description = "Property-based testing framework for Lean 4";
    homepage = "https://github.com/leanprover-community/plausible";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nadja-y ];
  };
}
