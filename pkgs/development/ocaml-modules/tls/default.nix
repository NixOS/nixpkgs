{
  lib,
  fetchurl,
  buildDunePackage,
  cstruct,
  domain-name,
  fmt,
  logs,
  hkdf,
  mirage-crypto,
  mirage-crypto-ec,
  mirage-crypto-pk,
  mirage-crypto-rng,
  lwt,
  ptime,
  x509,
  ipaddr,
  alcotest,
  cstruct-unix,
  ounit2,
  randomconv,
}:

buildDunePackage rec {
  pname = "tls";
  version = "0.17.3";

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-tls/releases/download/v${version}/tls-${version}.tbz";
    hash = "sha256-R+XezdMO0cNnc2RYpjrgd0dBR7PdZ1wUWQuBqS1QMdQ=";
  };

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    cstruct
    domain-name
    fmt
    logs
    hkdf
    mirage-crypto
    mirage-crypto-ec
    mirage-crypto-pk
    mirage-crypto-rng
    lwt
    ptime
    x509
    ipaddr
  ];

  doCheck = true;
  checkInputs = [
    alcotest
    cstruct-unix
    ounit2
    randomconv
  ];

  meta = with lib; {
    homepage = "https://github.com/mirleft/ocaml-tls";
    description = "TLS in pure OCaml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
