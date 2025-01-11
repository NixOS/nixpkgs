{
  lib,
  fetchurl,
  buildDunePackage,
  h2,
  httpaf,
  mimic-happy-eyeballs,
  mirage-clock,
  paf,
  tcpip,
  x509,
  alcotest-lwt,
  mirage-clock-unix,
  mirage-crypto-rng,
  mirage-time-unix,
}:

buildDunePackage rec {
  pname = "http-mirage-client";
  version = "0.0.8";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/roburio/http-mirage-client/releases/download/v${version}/http-mirage-client-${version}.tbz";
    hash = "sha256-/1eguh2dYLDVNW+XWNKcwm5IgQWfEFUuQRYS205Ox+c=";
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
