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

buildDunePackage (finalAttrs: {
  pname = "http-mirage-client";
  version = "0.0.10";

  minimalOCamlVersion = "4.08";

  __darwinAllowLocalNetworking = true;

  src = fetchurl {
    url = "https://github.com/robur-coop/http-mirage-client/releases/download/v${finalAttrs.version}/http-mirage-client-${finalAttrs.version}.tbz";
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
    homepage = "https://github.com/robur-coop/http-mirage-client";
    changelog = "https://github.com/robur-coop/http-mirage-client/blob/v${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
