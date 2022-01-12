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
  version = "0.0.6";

  src = fetchurl {
    url = "https://github.com/dinosaure/paf-le-chien/releases/download/${version}/paf-${version}.tbz";
    sha256 = "21adbe0f7f9c0242354fa996468d01bf21d5cbcbdd978c911df8e2e299e8f9ae";
  };

  useDune2 = true;
  minimumOCamlVersion = "4.08";

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
