{
  lib,
  buildDunePackage,
  fetchurl,
  digestif,
  mirage-crypto,
  alcotest,
  ohex,
}:

buildDunePackage (finalAttrs: {
  pname = "kdf";
  version = "1.1.2";

  src = fetchurl {
    url = "https://github.com/robur-coop/kdf/releases/download/v${finalAttrs.version}/kdf-${finalAttrs.version}.tbz";
    hash = "sha256-oyfh2qstNn11svuoX16CeIYpUiX5TAnmjiSi4qdQgQA=";
  };

  propagatedBuildInputs = [
    digestif
    mirage-crypto
  ];

  checkInputs = [
    alcotest
    ohex
  ];
  doCheck = true;

  meta = {
    description = "Key Derivation Functions: HKDF RFC 5869, PBKDF RFC 2898, SCRYPT RFC 7914";
    homepage = "https://github.com/robur-coop/kdf";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
