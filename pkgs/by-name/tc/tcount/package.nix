{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "tcount";
  version = "0-unstable-2023-04-20";

  src = fetchFromGitHub {
    owner = "rrethy";
    repo = "tcount";
    rev = "341d9aa29512257bf7dfd7e843d02fdcfd583387";
    hash = "sha256-M4EvaX9qDBYeapeegp6Ki7FJLFosVR1B42QRAh5Eugo=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-Sn7hu+2jQFd2u8tpfTxnEO+syrO96gfgz6ouHxJnpLg=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Count your code by tokens and patterns in the syntax tree. A tokei/scc/cloc alternative";
    homepage = "https://github.com/rrethy/tcount";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "tcount";
  };
}
