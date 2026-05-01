{
  lib,
  buildLakePackage,
  fetchFromGitHub,
  batteries,
}:

buildLakePackage {
  pname = "lean4-aesop";
  version = "4.29.0";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "aesop";
    tag = "v4.29.0";
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
