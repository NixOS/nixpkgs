{ lib
, fetchurl
, fetchpatch
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
  version = "0.0.2";

  duneVersion = "3";
  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/roburio/http-mirage-client/releases/download/v${version}/http-mirage-client-${version}.tbz";
    hash = "sha256-stom13t3Kn1ehkeURem39mxhd3Lmlz8z9m3tHGcp5vY=";
  };

  # Make tests use mirage-crypto
  patches = lib.lists.map fetchpatch [
    { url = "https://github.com/roburio/http-mirage-client/commit/c6cd38db9c23ac23e7c3e4cf2d41420f58034e8d.patch";
      hash = "sha256-b3rurqF0DxLpVQEhVfROwc7qyul0Fjfl3zhD8AkzemU="; }
    { url = "https://github.com/roburio/http-mirage-client/commit/0a5367e7c6d9b7f45c88493f7a596f7a83e8c7d5.patch";
      hash = "sha256-Q6YlfuiAfsyhty9EvoBetvekuU25KjrH5wwGwYTAAiA="; }
    ];

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
