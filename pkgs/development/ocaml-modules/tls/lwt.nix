{ lib, buildDunePackage, tls, lwt, mirage-crypto-rng-lwt, cmdliner, x509 }:

buildDunePackage rec {
  pname = "tls-lwt";

  inherit (tls) src meta version;

  minimalOCamlVersion = "4.11";
  duneVersion = "3";

  doCheck = true;

  propagatedBuildInputs = [
    lwt
    mirage-crypto-rng-lwt
    tls
    x509
  ];
}
