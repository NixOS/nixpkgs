{ lib, buildDunePackage, tls, async, cstruct-async, core, cstruct, mirage-crypto-rng-async }:

buildDunePackage rec {
  pname = "tls-async";

<<<<<<< HEAD
  inherit (tls) src version;

  minimalOCamlVersion = "4.14";
=======
  inherit (tls) src meta version;

  minimalOCamlVersion = "4.11";
  duneVersion = "3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = true;

  propagatedBuildInputs = [
    async
    core
    cstruct
    cstruct-async
    mirage-crypto-rng-async
    tls
  ];
<<<<<<< HEAD

  meta = tls.meta // {
    description = "Transport Layer Security purely in OCaml, Async layer";
  };
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
