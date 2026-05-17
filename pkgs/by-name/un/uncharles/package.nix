{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "uncharles";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "leopepe";
    repo = "automata-atelier";
    rev = "uncharles-v${version}";
    hash = "sha256-P3h/OtGga8lkSQs/OFky8Ik5S+EFEeNEmvjVaZiMArs=";
  };

  __structuredAttrs = true;

  cargoLock.lockFile = ./Cargo.lock;

  cargoBuildFlags = [
    "-p"
    "uncharles"
  ];
  cargoTestFlags = [
    "-p"
    "uncharles"
  ];

  meta = {
    description = "Sense → plan → act runtime that drives goap-planner from a YAML config to automate shell tasks";
    homepage = "https://github.com/leopepe/automata-atelier";
    changelog = "https://github.com/leopepe/automata-atelier/releases/tag/uncharles-v${version}";
    license = lib.licenses.mit;
    mainProgram = "uncharles";
    maintainers = with lib.maintainers; [ leopepe ];
    platforms = lib.platforms.unix;
  };
}
