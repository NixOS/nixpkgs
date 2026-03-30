{
  lib,
  buildLakePackage,
  fetchFromGitHub,
}:

buildLakePackage {
  pname = "lean4-plausible";
  version = "4.28.0";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "plausible";
    tag = "v4.28.0";
    hash = "sha256-xuOfeoRPt5L0Rk4fEJPIi1A0aoNIkC1fsh5yeIx5bFI=";
  };

  leanPackageName = "plausible";

  meta = {
    description = "Property-based testing framework for Lean 4";
    homepage = "https://github.com/leanprover-community/plausible";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nadja-y ];
  };
}
