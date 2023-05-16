{ lib, fetchFromGitHub, buildDunePackage
<<<<<<< HEAD
=======
, seq
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, containers, qcheck
}:

buildDunePackage rec {
<<<<<<< HEAD
  version = "0.5";
=======
  version = "0.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "oseq";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-JMIcRyciNvLOE1Gpin7CpcDNSmGYFxZWsDN0X6D/NVI=";
  };

  minimalOCamlVersion = "4.08";
=======
    hash = "sha256-FoCBvvPwa/dUCrgDEd0clEKAO7EcpedjaO4v+yUO874=";
  };

  propagatedBuildInputs = [ seq ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  duneVersion = "3";

  doCheck = true;
  checkInputs = [
    containers
    qcheck
  ];

  meta = {
    homepage = "https://c-cube.github.io/oseq/";
    description = "Purely functional iterators compatible with standard `seq`";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
