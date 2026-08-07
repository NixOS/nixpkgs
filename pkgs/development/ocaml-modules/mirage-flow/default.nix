{
  lib,
  buildDunePackage,
  fetchurl,
  cstruct,
  fmt,
  lwt,
}:

buildDunePackage (finalAttrs: {
  pname = "mirage-flow";
  version = "5.0.0";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-flow/releases/download/v${finalAttrs.version}/mirage-flow-${finalAttrs.version}.tbz";
    hash = "sha256-N8p5yuDtmycLh3Eu3LOXpd7Eqzk1eygQfgDapshVMyM=";
  };

  propagatedBuildInputs = [
    cstruct
    fmt
    lwt
  ];

  meta = {
    description = "Flow implementations and combinators for MirageOS";
    homepage = "https://github.com/mirage/mirage-flow";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
