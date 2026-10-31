{
  lib,
  buildLakePackage,
  fetchFromGitHub,
}:

buildLakePackage {
  pname = "lean4-Qq";
  # nixpkgs-update: no auto update
  version = "4.35.0-unstable-2026-10-12";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "quote4";
    rev = "dce0ad79c486cb1fb504af04f953c3466b0c6db8";
    hash = "sha256-mcSBP2pqVRdoPc2fVN45xxw7e13L5tuRf+v0j01Co8I=";
  };

  leanPackageName = "Qq";

  meta = {
    description = "Lean 4 compile-time quote and antiquote macros for metaprogramming";
    homepage = "https://github.com/leanprover-community/quote4";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nadja-y ];
  };
}
