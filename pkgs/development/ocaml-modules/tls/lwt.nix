{ buildDunePackage, tls, lwt, mirage-crypto-rng-lwt, x509 }:

buildDunePackage rec {
  pname = "tls-lwt";

  inherit (tls) src meta version;

  minimalOCamlVersion = "4.11";

  doCheck = true;

  propagatedBuildInputs = [
    lwt
    mirage-crypto-rng-lwt
    tls
    x509
  ];
}
