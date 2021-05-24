{ buildDunePackage
, lib
, fetchurl
, astring
, asn1-combinators
, uri
, rresult
, base64
, cmdliner
, cohttp
, cohttp-lwt
, cohttp-lwt-unix
, zarith
, logs
, fmt
, lwt
, mirage-crypto
, mirage-crypto-pk
, mirage-crypto-rng
, x509
, yojson
, ounit
, dns
, dns-tsig
, ptime
, bos
, fpath
, randomconv
, domain-name
}:

buildDunePackage rec {
  pname = "letsencrypt";
  version = "0.2.5";

  src = fetchurl {
    url = "https://github.com/mmaker/ocaml-letsencrypt/releases/download/v${version}/letsencrypt-v${version}.tbz";
    sha256 = "6e3bbb5f593823d49e83e698c06cf9ed48818695ec8318507b311ae74731e607";
  };

  minimumOCamlVersion = "4.08";
  useDune2 = true;

  buildInputs = [
    cmdliner
    cohttp
    cohttp-lwt-unix
    zarith
    fmt
    mirage-crypto-rng
    ptime
    bos
    fpath
    randomconv
    domain-name
  ];

  propagatedBuildInputs = [
    logs
    yojson
    lwt
    base64
    mirage-crypto
    mirage-crypto-pk
    asn1-combinators
    x509
    uri
    dns
    dns-tsig
    rresult
    astring
    cohttp-lwt
  ];

  doCheck = true;
  checkInputs = [ ounit ];

  meta = {
    description = "ACME implementation in OCaml";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.sternenseemann ];
    homepage = "https://github.com/mmaker/ocaml-letsencrypt";
  };
}
