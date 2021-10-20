{ buildDunePackage
, lib
, fetchurl
, astring
, asn1-combinators
, uri
, rresult
, base64
, logs
, fmt
, lwt
, mirage-crypto
, mirage-crypto-pk
, mirage-crypto-rng
, x509
, yojson
, ounit
, ptime
, domain-name
}:

buildDunePackage rec {
  pname = "letsencrypt";
  version = "0.3.0";

  src = fetchurl {
    url = "https://github.com/mmaker/ocaml-letsencrypt/releases/download/v${version}/letsencrypt-v${version}.tbz";
    sha256 = "8772b7e6dbda0559a03a7b23b75c1431d42ae09a154eefd64b4c7e23b8d92deb";
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
    mirage-crypto-pk
    asn1-combinators
    x509
    uri
    rresult
    astring
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
