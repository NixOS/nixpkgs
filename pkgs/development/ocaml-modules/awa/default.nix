{
  lib,
  buildDunePackage,
  fetchurl,
  mirage-crypto,
  mirage-crypto-ec,
  mirage-crypto-rng,
  mirage-crypto-pk,
  x509,
  cstruct,
  cstruct-unix,
  eqaf,
  mtime,
  logs,
  fmt,
  cmdliner,
  base64,
  zarith,
  mirage-mtime,
}:

buildDunePackage (finalAttrs: {
  pname = "awa";
  version = "0.5.2";

  src = fetchurl {
    url = "https://github.com/mirage/awa-ssh/releases/download/v${finalAttrs.version}/awa-${finalAttrs.version}.tbz";
    hash = "sha256-64gloekVN0YsBwUodrJc6QaNU3PGKMIZMPJWvBfzaj0=";
  };

  propagatedBuildInputs = [
    mirage-crypto
    mirage-crypto-ec
    mirage-crypto-rng
    mirage-crypto-pk
    x509
    cstruct
    mtime
    logs
    base64
    zarith
    eqaf
  ];

  doCheck = true;
  checkInputs = [
    cstruct-unix
    cmdliner
    fmt
    mirage-mtime
  ];

  meta = {
    description = "SSH implementation in OCaml";
    homepage = "https://github.com/mirage/awa-ssh";
    changelog = "https://github.com/mirage/awa-ssh/raw/v${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
})
