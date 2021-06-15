{ buildDunePackage
, lib
, fetchurl
, fetchpatch
, mirage-stack
, mirage-time
, httpaf
, h2
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
  version = "0.0.3";

  src = fetchurl {
    url = "https://github.com/dinosaure/paf-le-chien/releases/download/${version}/paf-${version}.tbz";
    sha256 = "a0bbb84b19e1f0255337fc4d7017f3ea3611b241746e391b11c1d8b1f5f30a2b";
  };

  useDune2 = true;
  minimumOCamlVersion = "4.08";

  propagatedBuildInputs = [
    mirage-stack
    mirage-time
    httpaf
    h2
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
