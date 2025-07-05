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
  version = "2.0.1";

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-tls/releases/download/v${version}/tls-${version}.tbz";
    hash = "sha256-a6uNo61SjT8xLXtO4h2kxZw0qRrj5c9CNHFauaGCDq0=";
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

  meta = with lib; {
    homepage = "https://github.com/mirleft/ocaml-tls";
    description = "TLS in pure OCaml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
