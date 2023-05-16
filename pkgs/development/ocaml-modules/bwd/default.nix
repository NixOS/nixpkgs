{ lib, fetchFromGitHub, buildDunePackage, qcheck-core }:

buildDunePackage rec {
  pname = "bwd";
<<<<<<< HEAD
  version = "2.2.0";
=======
  version = "2.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  minimalOCamlVersion = "4.12";
  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "RedPRL";
    repo = "ocaml-bwd";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-4DttkEPI9yJtMsqzTNSnoDajcvMQPIiJAHk0kJl540Y=";
=======
    hash = "sha256-ucXOBjD1behL2h8CZv64xtRjCPkajZic7G1oxxDmEXY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  doCheck = true;
  checkInputs = [ qcheck-core ];

  meta = {
    description = "Backward Lists";
<<<<<<< HEAD
    homepage = "https://github.com/RedPRL/ocaml-bwd";
    changelog = "https://github.com/RedPRL/ocaml-bwd/blob/${version}/CHANGELOG.markdown";
=======
    inherit (src.meta) homepage;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
