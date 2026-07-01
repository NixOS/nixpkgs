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
  ptime,
  x509,
  ipaddr,
  alcotest,
  ounit2,
}:

buildDunePackage (finalAttrs: {
  pname = "tls";
  version = "2.1.1";

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-tls/releases/download/v${finalAttrs.version}/tls-${finalAttrs.version}.tbz";
    hash = "sha256-EL34iiXOiRCDzsGLc6vnOvLGmhnkLT2VFq5ZctrD8wc=";
  };

  propagatedBuildInputs = [
    domain-name
    fmt
    logs
    kdf
    mirage-crypto
    mirage-crypto-ec
    mirage-crypto-pk
    mirage-crypto-rng
    ptime
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
})
