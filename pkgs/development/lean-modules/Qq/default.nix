{
  lib,
  buildLakePackage,
  fetchFromGitHub,
}:

buildLakePackage {
  pname = "lean4-Qq";
  version = "4.28.0";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "quote4";
    tag = "v4.28.0";
    hash = "sha256-BRrSdDJQAsgM/NeSL2FODCez/8zEffjDRWUToGlKDNQ=";
  };

  leanPackageName = "Qq";

  meta = {
    description = "Lean 4 compile-time quote and antiquote macros for metaprogramming";
    homepage = "https://github.com/leanprover-community/quote4";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nadja-y ];
  };
}
