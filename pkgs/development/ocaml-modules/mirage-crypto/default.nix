{
  lib,
  fetchurl,
  buildDunePackage,
  ohex,
  ounit2,
  dune-configurator,
  eqaf,
}:

buildDunePackage (finalAttrs: {
  minimalOCamlVersion = "4.13";

  pname = "mirage-crypto";
  version = "2.0.2";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-crypto/releases/download/v${finalAttrs.version}/mirage-crypto-${finalAttrs.version}.tbz";
    hash = "sha256-c5qdOfNAJ/vJNVf4fFysQZClK92t/3LyEvqoA9YhWHQ=";
  };

  doCheck = true;
  checkInputs = [
    ohex
    ounit2
  ];

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    eqaf
  ];

  meta = {
    homepage = "https://github.com/mirage/mirage-crypto";
    description = "Simple symmetric cryptography for the modern age";
    changelog = "https://raw.githubusercontent.com/mirage/mirage-crypto/refs/tags/v${finalAttrs.version}/CHANGES.md";
    license = with lib.licenses; [
      isc # default license
      bsd2 # mirage-crypto-rng-mirage
      mit # mirage-crypto-ec
    ];
    maintainers = with lib.maintainers; [
      sternenseemann
      momeemt
    ];
  };
})
