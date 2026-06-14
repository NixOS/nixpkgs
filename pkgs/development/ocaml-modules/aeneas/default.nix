{
  lib,
  buildDunePackage,
  fetchFromGitHub,

  # propagatedBuildInputs,
  charon,
  core_unix,
  domainslib,
  ocamlgraph,
  progress,
  visitors,

  nix-update-script,
}:

buildDunePackage (finalAttrs: {
  pname = "aeneas";
  version = "2026.06.12";
  __structuredAttrs = true;

  minimalOCamlVersion = "5.1";

  src = fetchFromGitHub {
    owner = "AeneasVerif";
    repo = "aeneas";
    tag = "nightly-${finalAttrs.version}";
    hash = "sha256-loTnCy4lNJki+dSShZ35jKyOWIh1XcPwN7oY7CyFa04=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  propagatedBuildInputs = [
    charon
    core_unix
    domainslib
    ocamlgraph
    progress
    visitors
  ];

  # The test suite consists of heavy integration tests that require the full
  # toolchain (Rust, charon and the F*/Coq/Lean backends), so it is not run here.
  doCheck = false;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=unstable" ];
  };

  meta = {
    description = "Verification toolchain for Rust programs";
    homepage = "https://github.com/AeneasVerif/aeneas";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "aeneas";
    platforms = lib.platforms.all;
  };
})
