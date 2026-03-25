{
  lib,
  buildLakePackage,
  fetchFromGitHub,
  batteries,
}:

buildLakePackage {
  pname = "lean4-aesop";
  version = "4.28.0";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "aesop";
    tag = "v4.28.0";
    hash = "sha256-KeP46qtEf4/lgi4iCVuYIQbazufTR4luTbsuia9JkK4=";
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
