{
  lib,
  buildLakePackage,
  fetchFromGitHub,
  batteries,
  aesop,
  Qq,
  proofwidgets,
  plausible,
  LeanSearchClient,
  importGraph,
  tests,
}:

buildLakePackage {
  pname = "lean4-mathlib";
  version = "4.29.0";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "mathlib4";
    tag = "v4.29.0";
    hash = "sha256-fe+qS7gNxdLnACX3/jqToa9m7r1gbskY6kDJbm1ZefE=";
  };

  leanPackageName = "mathlib";
  leanDeps = [
    batteries
    aesop
    Qq
    proofwidgets
    plausible
    LeanSearchClient
    importGraph
  ];

  requiredSystemFeatures = [ "big-parallel" ];

  passthru.tests = {
    inherit (tests.lake) weak-minimax;
  };

  meta = {
    description = "Mathematical library for Lean 4";
    homepage = "https://github.com/leanprover-community/mathlib4";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nadja-y ];
  };
}
