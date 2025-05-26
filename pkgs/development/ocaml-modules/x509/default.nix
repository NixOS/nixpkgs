{
  lib,
  fetchurl,
  buildDunePackage,
  alcotest,
  asn1-combinators,
  domain-name,
  fmt,
  gmap,
  kdf,
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
  version = "1.0.6";

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-x509/releases/download/v${version}/x509-${version}.tbz";
    hash = "sha256-/IFq4sZei0L6YNkKUHshQEleKNCVrTeyfkwmiuPADWw=";
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
    kdf
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
