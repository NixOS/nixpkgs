{ lib, buildDunePackage, tls, lwt, mirage-crypto-rng-lwt, cmdliner, x509 }:

buildDunePackage rec {
  pname = "tls-lwt";

  inherit (tls) src meta version;

  minimalOCamlVersion = "4.11";
<<<<<<< HEAD
=======
  duneVersion = "3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = true;

  propagatedBuildInputs = [
    lwt
    mirage-crypto-rng-lwt
    tls
    x509
  ];
}
