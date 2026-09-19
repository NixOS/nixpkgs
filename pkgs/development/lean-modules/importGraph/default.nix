{
  lib,
  buildLakePackage,
  fetchFromGitHub,
  Cli,
}:

buildLakePackage {
  pname = "lean4-importGraph";
  # nixpkgs-update: no auto update
  version = "4.33.0-unstable-2026-08-10";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "import-graph";
    rev = "16f02aa7642864af59f1ff0e384a015994db9118";
    hash = "sha256-3rjLQXQX0mlAbr68zGC4pL9mrqJ7GFVaeJ8HJ2oM3pE=";
  };

  leanPackageName = "importGraph";
  leanDeps = [ Cli ];

  meta = {
    description = "Tools to analyse and visualise Lean 4 import structures";
    homepage = "https://github.com/leanprover-community/import-graph";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nadja-y ];
  };
}
