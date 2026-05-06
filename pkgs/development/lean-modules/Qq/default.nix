{
  lib,
  buildLakePackage,
  fetchFromGitHub,
}:

buildLakePackage {
  pname = "lean4-Qq";
  # nixpkgs-update: no auto update
  version = "4.29.0-unstable-2026-03-28";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "quote4";
    rev = "707efb56d0696634e9e965523a1bbe9ac6ce141d";
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
