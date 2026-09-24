{
  lib,
  buildLakePackage,
  fetchFromGitHub,
  Cli,
}:

buildLakePackage {
  pname = "lean4-importGraph";
  # nixpkgs-update: no auto update
  version = "4.30.0-unstable-2026-05-26";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "import-graph";
    rev = "515cf9d0c00ece5e661f6de4326a53dedc1e8ea1";
    hash = "sha256-V3bGQxTNs2G4MqaVxRb6WED1a7VaHfEo1HgBNqPipz8=";
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
