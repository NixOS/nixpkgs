{
  lib,
  buildLakePackage,
  fetchFromGitHub,
  Cli,
}:

buildLakePackage {
  pname = "lean4-importGraph";
  # nixpkgs-update: no auto update
  version = "4.36.0-unstable-2026-11-16";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "import-graph";
    rev = "8370c640afcd1cc3fb1cb9bf1560cc66eafee5e0";
    hash = "sha256-4Wb7qnIbs1OJ1yI5km3kNKFXfVfWPwDP+H/UmaOFzto=";
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
