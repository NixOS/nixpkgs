{
  lib,
  buildLakePackage,
  fetchFromGitHub,
}:

buildLakePackage {
  pname = "lean4-plausible";
  # nixpkgs-update: no auto update
  version = "4.29.0-unstable-2026-03-28";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "plausible";
    rev = "83e90935a17ca19ebe4b7893c7f7066e266f50d3";
    hash = "sha256-08fNB2GK5AqDJ15n5Ol+HYqaSbsznyp4cerDo32bG50=";
  };

  leanPackageName = "plausible";

  meta = {
    description = "Property-based testing framework for Lean 4";
    homepage = "https://github.com/leanprover-community/plausible";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nadja-y ];
  };
}
