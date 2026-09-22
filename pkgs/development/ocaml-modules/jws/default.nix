{
  lib,
  buildDunePackage,
  fetchurl,
  base64,
  digestif,
  jsont,
  mirage-crypto-ec,
  mirage-crypto-pk,
  mirage-crypto-rng,
  ounit2,
  x509,
}:

buildDunePackage (finalAttrs: {
  pname = "jws";
  version = "0.0.2";
  src = fetchurl {
    url = "https://github.com/robur-coop/jws/releases/download/v${finalAttrs.version}/jws-${finalAttrs.version}.tbz";
    hash = "sha256-7qcxmuhMNkm0xyzVn2MI+mLyO7UbQe+4r0o6CX3XHD0=";
  };

  propagatedBuildInputs = [
    base64
    digestif
    jsont
    mirage-crypto-ec
    mirage-crypto-pk
  ];

  doCheck = true;
  checkInputs = [
    mirage-crypto-rng
    ounit2
    x509
  ];

  meta = {
    homepage = "https://git.robur.coop/robur/jws";
    description = "Implementation of JSON Web Signature/Token (RFC 7515)";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
