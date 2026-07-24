{
  lib,
  buildLakePackage,
  fetchFromGitHub,
}:

buildLakePackage {
  pname = "lean4-plausible";
  # nixpkgs-update: no auto update
  version = "4.33.0-unstable-2026-08-10";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "plausible";
    rev = "b7eb3304aeae834b12dda98993a37f6a41f6f0bb";
    hash = "sha256-BE/kaFjz8mdUFodEQo35jgCjEoZPD6ipdJqAm5v/VBo=";
  };

  leanPackageName = "plausible";

  meta = {
    description = "Property-based testing framework for Lean 4";
    homepage = "https://github.com/leanprover-community/plausible";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nadja-y ];
  };
}
