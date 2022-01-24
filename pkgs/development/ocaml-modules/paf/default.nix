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
  version = "0.0.8";

  src = fetchurl {
    url = "https://github.com/dinosaure/paf-le-chien/releases/download/${version}/paf-${version}.tbz";
    sha256 = "CyIIV11G7oUPPHuhov52LP4Ih4pY6bcUApD23/9q39k=";
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
    tcpip
  ];

  doCheck = false;
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
