{
  lib,
  fetchurl,
  buildDunePackage,
  alcotest,
  asn1-combinators,
  domain-name,
  fmt,
  gmap,
  pbkdf,
  mirage-crypto,
  mirage-crypto-ec,
  mirage-crypto-pk,
  ipaddr,
  logs,
  base64,
  ohex,
}:

buildDunePackage rec {
  minimalOCamlVersion = "4.08";

  pname = "x509";
  version = "1.0.2";

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-x509/releases/download/v${version}/x509-${version}.tbz";
    hash = "sha256-LrUYbLLJTNCWvEZtRXUv5LHdEya2oNTtAbrfm7EE2Bg=";
  };

  checkInputs = [ alcotest ];
  propagatedBuildInputs = [
    asn1-combinators
    domain-name
    fmt
    gmap
    mirage-crypto
    mirage-crypto-pk
    mirage-crypto-ec
    pbkdf
    logs
    base64
    ipaddr
    ohex
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/mirleft/ocaml-x509";
    description = "X509 (RFC5280) handling in OCaml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ vbgl ];
  };
}
