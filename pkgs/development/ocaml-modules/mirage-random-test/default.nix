{
  lib,
  buildDunePackage,
  fetchurl,
  cstruct,
  mirage-random,
}:

buildDunePackage (finalAttrs: {
  pname = "mirage-random-test";
  version = "0.1.0";

  minimalOCamlVersion = "4.06";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-random-test/releases/download/v${finalAttrs.version}/mirage-random-test-v${finalAttrs.version}.tbz";
    hash = "sha256-huyJJl9WhXKb8Ebl5eGYHeUP9U/58vZ6B/RsotLysso=";
  };

  propagatedBuildInputs = [
    cstruct
    mirage-random
  ];

  meta = {
    description = "Stub random device implementation for testing";
    homepage = "https://github.com/mirage/mirage-random";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
})
