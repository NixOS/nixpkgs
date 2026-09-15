{
  lib,
  buildLakePackage,
  fetchFromGitHub,
}:

buildLakePackage {
  pname = "lean4-Qq";
  # nixpkgs-update: no auto update
  version = "4.33.0-unstable-2026-08-10";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "quote4";
    rev = "92c15be17b7caf78c2ad767ec40f89052d908d81";
    hash = "sha256-gQ//zSdkl+70c3KI7gbXJjupxMXgL0GKkxg8llTV+c8=";
  };

  leanPackageName = "Qq";

  meta = {
    description = "Lean 4 compile-time quote and antiquote macros for metaprogramming";
    homepage = "https://github.com/leanprover-community/quote4";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nadja-y ];
  };
}
