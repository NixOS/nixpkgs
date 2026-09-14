{
  lib,
  fetchurl,
  buildDunePackage,
  digestif,
  domain-name,
  fmt,
  logs,
  kdf,
  mirage-crypto,
  mirage-crypto-ec,
  mirage-crypto-pk,
  mirage-crypto-rng,
  ohex,
  ptime,
  x509,
  ipaddr,
  alcotest,
  ounit2,
}:

buildDunePackage (finalAttrs: {
  pname = "tls";
  version = "2.1.3";

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-tls/releases/download/v${finalAttrs.version}/tls-${finalAttrs.version}.tbz";
    hash = "sha256-kNBOBvogamm10TewF+URwUG5WeXHkp58uKFRVTIkej8=";
  };

  propagatedBuildInputs = [
    digestif
    domain-name
    fmt
    ipaddr
    kdf
    logs
    mirage-crypto
    mirage-crypto-ec
    mirage-crypto-pk
    mirage-crypto-rng
    ohex
    ptime
    x509
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
