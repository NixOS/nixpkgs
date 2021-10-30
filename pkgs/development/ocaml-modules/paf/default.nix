{ buildDunePackage
, lib
, fetchurl
, fetchpatch
, mirage-stack
, mirage-time
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
, cstruct
}:

buildDunePackage rec {
  pname = "paf";
  version = "0.0.5";

  src = fetchurl {
    url = "https://github.com/dinosaure/paf-le-chien/releases/download/${version}/paf-${version}.tbz";
    sha256 = "e85a018046eb062d2399fdbe8d9d3400a4d5cd51bb62840446503f557c3eeff1";
  };

  useDune2 = true;
  minimumOCamlVersion = "4.08";

  propagatedBuildInputs = [
    mirage-stack
    mirage-time
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
    cstruct
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
