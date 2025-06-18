{
  lib,
  fetchurl,
  buildDunePackage,
  h2,
  h1,
  mimic-happy-eyeballs,
  paf,
  tcpip,
  x509,
  alcotest-lwt,
  mirage-crypto-rng,
}:

buildDunePackage rec {
  pname = "http-mirage-client";
  version = "0.0.10";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/roburio/http-mirage-client/releases/download/v${version}/http-mirage-client-${version}.tbz";
    hash = "sha256-AXEIH1TIAayD4LkFv0yGD8OYvcdC/AJnGudGlkjcWLY=";
  };

  propagatedBuildInputs = [
    h2
    h1
    mimic-happy-eyeballs
    paf
    tcpip
    x509
  ];

  doCheck = true;
  checkInputs = [
    alcotest-lwt
    mirage-crypto-rng
  ];

  meta = {
    description = "HTTP client for MirageOS";
    homepage = "https://github.com/roburio/http-mirage-client";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
