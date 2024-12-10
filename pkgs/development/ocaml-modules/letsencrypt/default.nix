{
  buildDunePackage,
  lib,
  fetchurl,
  asn1-combinators,
  uri,
  base64,
  logs,
  fmt,
  lwt,
  mirage-crypto,
  mirage-crypto-ec,
  mirage-crypto-pk,
  mirage-crypto-rng,
  x509,
  yojson,
  ounit,
  ptime,
  domain-name,
  cstruct,
}:

buildDunePackage rec {
  pname = "letsencrypt";
  version = "0.5.1";

  src = fetchurl {
    url = "https://github.com/mmaker/ocaml-letsencrypt/releases/download/v${version}/letsencrypt-${version}.tbz";
    hash = "sha256-uQOHpdyPg5kms+negxpQMxfhow6auZ0ipt5ksoXYo1w=";
  };

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

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
