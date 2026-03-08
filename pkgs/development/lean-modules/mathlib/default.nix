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
}:

buildLakePackage {
  pname = "lean4-mathlib";
  version = "4.28.0";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "mathlib4";
    tag = "v4.28.0";
    hash = "sha256-7kR0WvEDey5kEdqKKVEO/JgQd1VyB6a+zwPvIV5E5Pg=";
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

  meta = {
    description = "Mathematical library for Lean 4";
    homepage = "https://github.com/leanprover-community/mathlib4";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nadja-y ];
  };
}
