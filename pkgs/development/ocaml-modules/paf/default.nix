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
  version = "0.2.0";

  src = fetchurl {
    url = "https://github.com/dinosaure/paf-le-chien/releases/download/${version}/paf-${version}.tbz";
    sha256 = "sha256-TzhRxFTPkLMAsLPl0ONC8DRhJRGstF58+QRKbGuJZVE=";
  };

  minimalOCamlVersion = "4.08";

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

  meta = {
    description = "HTTP/AF and MirageOS";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sternenseemann ];
    homepage = "https://github.com/dinosaure/paf-le-chien";
  };
}
