{ buildDunePackage
, lib
, fetchurl
, asn1-combinators
, uri
, base64
, logs
, fmt
, lwt
, mirage-crypto
, mirage-crypto-ec
, mirage-crypto-pk
, mirage-crypto-rng
, x509
, yojson
, ounit
, ptime
, domain-name
, cstruct
}:

buildDunePackage rec {
  pname = "letsencrypt";
  version = "0.4.1";

  src = fetchurl {
    url = "https://github.com/mmaker/ocaml-letsencrypt/releases/download/v${version}/letsencrypt-v${version}.tbz";
    sha256 = "f90875f5c9bdcab4c8be5ec7ebe9ea763030fa708e02857300996bb16e7c2070";
  };

  minimumOCamlVersion = "4.08";
  useDune2 = true;

  buildInputs = [
    fmt
    ptime
    domain-name
  ];

  propagatedBuildInputs = [
    logs
    yojson
    lwt
    base64
    mirage-crypto
    mirage-crypto-ec
    mirage-crypto-pk
    asn1-combinators
    x509
    uri
    cstruct
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
