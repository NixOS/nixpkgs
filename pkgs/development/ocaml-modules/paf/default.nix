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
  version = "0.3.0";

  src = fetchurl {
    url = "https://github.com/dinosaure/paf-le-chien/releases/download/${version}/paf-${version}.tbz";
    sha256 = "sha256-+RkrmWJJREHg8BBdNe92vYhd2/Frvs7l5qOr9jBwymU=";
  };

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
