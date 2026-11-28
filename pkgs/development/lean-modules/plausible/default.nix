{
  lib,
  buildLakePackage,
  fetchFromGitHub,
}:

buildLakePackage {
  pname = "lean4-plausible";
  # nixpkgs-update: no auto update
  version = "4.36.0-unstable-2026-11-16";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "plausible";
    rev = "054b228ce0ac61d767c6e71ba73a24728f191b72";
    hash = "sha256-YMDN+GQ8Smv3NuEt73ihj/k/M9jxuZf5A9RoMZMa8yI=";
  };

  leanPackageName = "plausible";

  meta = {
    description = "Property-based testing framework for Lean 4";
    homepage = "https://github.com/leanprover-community/plausible";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nadja-y ];
  };
}
