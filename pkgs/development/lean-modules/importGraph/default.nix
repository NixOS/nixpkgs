{
  lib,
  buildLakePackage,
  fetchFromGitHub,
  Cli,
}:

buildLakePackage {
  pname = "lean4-importGraph";
  version = "4.29.0";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "import-graph";
    tag = "v4.29.0";
    hash = "sha256-tqdO2qyWiJzEbK0yuu4+tiOXTEg9XJfGnI7z6Jh/abg=";
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
