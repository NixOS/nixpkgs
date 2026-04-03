{
  lib,
  buildLakePackage,
  fetchFromGitHub,
}:

buildLakePackage {
  pname = "lean4-batteries";
  version = "4.29.0";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "batteries";
    tag = "v4.29.0";
    hash = "sha256-sEIDi2i2FaLTgKYWt/kzqPrjMdf+bFURfhw6ZZWBawQ=";
  };

  leanPackageName = "batteries";

  meta = {
    description = "The batteries-included extended library for Lean 4";
    homepage = "https://github.com/leanprover-community/batteries";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nadja-y ];
  };
}
