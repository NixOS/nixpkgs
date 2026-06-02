{
  lib,
  buildLakePackage,
  fetchFromGitHub,
  Cli,
}:

buildLakePackage {
  pname = "lean4-importGraph";
  version = "4.30.0";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "import-graph";
    tag = "v4.30.0";
    hash = "sha256-V3bGQxTNs2G4MqaVxRb6WED1a7VaHfEo1HgBNqPipz8=";
  };

  leanPackageName = "importGraph";
  leanDeps = [ Cli ];

  meta = {
    description = "Tools to analyse and visualise Lean 4 import structures";
    homepage = "https://github.com/leanprover-community/import-graph";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      nadja-y
      niklashh
    ];
  };
}
