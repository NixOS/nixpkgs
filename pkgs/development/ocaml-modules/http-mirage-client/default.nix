{ lib
, fetchurl
, buildDunePackage
, h2
, httpaf
, mimic-happy-eyeballs
, mirage-clock
, paf
, tcpip
, x509
, alcotest-lwt
, mirage-clock-unix
, mirage-crypto-rng
, mirage-time-unix
}:

buildDunePackage rec {
  pname = "http-mirage-client";
<<<<<<< HEAD
  version = "0.0.5";

=======
  version = "0.0.3";

  duneVersion = "3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/roburio/http-mirage-client/releases/download/v${version}/http-mirage-client-${version}.tbz";
<<<<<<< HEAD
    hash = "sha256-w/dMv5QvgglTFj9V4wRoDqK+36YeE0xWLxcAVS0oHz0=";
=======
    hash = "sha256-6PMxZQfPiDTFbj9gOO2tW5FHF0MUP5tOySjkYg+QwGA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    h2
    httpaf
    mimic-happy-eyeballs
    mirage-clock
    paf
    tcpip
    x509
  ];

  doCheck = true;
  checkInputs = [
    alcotest-lwt
    mirage-clock-unix
    mirage-crypto-rng
    mirage-time-unix
  ];

  meta = {
    description = "HTTP client for MirageOS";
    homepage = "https://github.com/roburio/http-mirage-client";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
