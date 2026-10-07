{
  lib,
  buildLakePackage,
  fetchFromGitHub,
  Cli,
}:

buildLakePackage {
  pname = "lean4-importGraph";
  # nixpkgs-update: no auto update
  version = "4.34.0-unstable-2026-09-14";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "import-graph";
    rev = "e928b72544873815af278d38681b31c0293588e3";
    hash = "sha256-U3eskYuk2vJ35IJqBsIgOHKL03UHtlEriyssNkBxwjM=";
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
