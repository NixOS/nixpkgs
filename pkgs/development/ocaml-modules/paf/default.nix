{ buildDunePackage
, lib
, fetchurl
, fetchpatch
, mirage-stack
, mirage-time
, h2
, tls-mirage
, mimic
, ke
, bigstringaf
, faraday
, tls
, lwt
, logs
, fmt
, mirage-crypto-rng
, tcpip
, mirage-time-unix
, ptime
, uri
, alcotest-lwt
, cstruct
}:

buildDunePackage rec {
  pname = "paf";
  version = "0.4.0";

  src = fetchurl {
    url = "https://github.com/dinosaure/paf-le-chien/releases/download/${version}/paf-${version}.tbz";
    hash = "sha256-ux8fk4XDdih4Ua9NGOJVSuPseJBPv6+6ND/esHrluQE=";
  };

  patches = [
    # Compatibility with mirage-crypto 0.11.0
    (fetchpatch {
      url = "https://github.com/dinosaure/paf-le-chien/commit/2f308c1c4d3ff49d42136f8ff86a4385661e4d1b.patch";
      hash = "sha256-jmSeUpoRoUMPUNEH3Av2LxgRZs+eAectK+CpoH+SdpY=";
    })
  ];

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  propagatedBuildInputs = [
    mirage-stack
    mirage-time
    h2
    tls-mirage
    mimic
    ke
    bigstringaf
    faraday
    tls
    cstruct
    tcpip
  ];

  doCheck = true;
  checkInputs = [
    lwt
    logs
    fmt
    mirage-crypto-rng
    mirage-time-unix
    ptime
    uri
    alcotest-lwt
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "HTTP/AF and MirageOS";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sternenseemann ];
    homepage = "https://github.com/dinosaure/paf-le-chien";
  };
}
