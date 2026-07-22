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

buildDunePackage (finalAttrs: {
  pname = "x509";
  version = "1.1.1";

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-x509/releases/download/v${finalAttrs.version}/x509-${finalAttrs.version}.tbz";
    hash = "sha256-trFZ3Fa6RcNzAn8g5gd5te+Nb7eFTotCio3Zr+FAylU=";
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

  meta = {
    homepage = "https://github.com/mirleft/ocaml-x509";
    description = "X509 (RFC5280) handling in OCaml";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
