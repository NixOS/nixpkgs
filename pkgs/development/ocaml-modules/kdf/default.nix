{
  lib,
  buildDunePackage,
  fetchurl,
  digestif,
  mirage-crypto,
  alcotest,
  ohex,
}:

buildDunePackage rec {
  pname = "kdf";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/robur-coop/kdf/releases/download/v${version}/kdf-${version}.tbz";
    hash = "sha256-0WFYKw7+ZtlY3WuMnCEGjp9kVM4hg3fWz4eCPexi4M4=";
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
}
