{
  lib,
  buildLakePackage,
  fetchFromGitHub,
}:

buildLakePackage {
  pname = "lean4-Qq";
  version = "4.29.0";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "quote4";
    tag = "v4.29.0";
    hash = "sha256-pNY5hv1nJbreCfU4EewIHCpiryIBv1ghWibrUW8vnQ0=";
  };

  leanPackageName = "Qq";

  meta = {
    description = "Lean 4 compile-time quote and antiquote macros for metaprogramming";
    homepage = "https://github.com/leanprover-community/quote4";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nadja-y ];
  };
}
