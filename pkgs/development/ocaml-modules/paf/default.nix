{ buildDunePackage
, lib
, fetchurl
, fetchpatch
, mirage-stack
, mirage-time
, httpaf
, tls-mirage
, mimic
, cohttp-lwt
, letsencrypt
, emile
, ke
, bigstringaf
, domain-name
, duration
, faraday
, ipaddr
, tls
, x509
, lwt
, logs
, fmt
, mirage-crypto-rng
, tcpip
, mirage-time-unix
, ptime
, uri
, alcotest-lwt
}:

buildDunePackage rec {
  pname = "paf";
  version = "0.0.1";

  src = fetchurl {
    url = "https://github.com/dinosaure/paf-le-chien/releases/download/${version}/paf-${version}.tbz";
    sha256 = "7a794c21ce458bda302553b0f5ac128c067579fbb3b7b8fba9b410446c43e790";
  };

  useDune2 = true;
  minimumOCamlVersion = "4.08";

  propagatedBuildInputs = [
    mirage-stack
    mirage-time
    httpaf
    tls-mirage
    mimic
    cohttp-lwt
    letsencrypt
    emile
    ke
    bigstringaf
    domain-name
    ipaddr
    duration
    faraday
    tls
    x509
  ];

  doCheck = true;
  checkInputs = [
    lwt
    logs
    fmt
    mirage-crypto-rng
    tcpip
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
