{
  lib,
  fetchurl,
  buildDunePackage,
  domain-name,
  fmt,
  logs,
  kdf,
  mirage-crypto,
  mirage-crypto-ec,
  mirage-crypto-pk,
  mirage-crypto-rng,
  x509,
  ipaddr,
  alcotest,
  ounit2,
}:

buildDunePackage rec {
  pname = "tls";
  version = "2.0.3";

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-tls/releases/download/v${version}/tls-${version}.tbz";
    hash = "sha256-1xWbp0Xz2i5zhENT8CD9vHZzk4grR1Zfi2G5QcNRw9c=";
  };

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    domain-name
    fmt
    logs
    kdf
    mirage-crypto
    mirage-crypto-ec
    mirage-crypto-pk
    mirage-crypto-rng
    x509
    ipaddr
  ];

  doCheck = true;
  checkInputs = [
    alcotest
    ounit2
  ];

  meta = {
    homepage = "https://github.com/mirleft/ocaml-tls";
    description = "TLS in pure OCaml";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
}
