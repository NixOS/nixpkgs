{
  lib,
  buildDunePackage,
  fetchurl,
  cstruct,
  fmt,
  ipaddr,
  macaddr,
  ohex,
}:

buildDunePackage (finalAttrs: {
  pname = "charrua";
  version = "3.2.0";

  __structuredAttrs = true;

  minimalOCamlVersion = "4.13";

  src = fetchurl {
    url = "https://github.com/mirage/charrua/releases/download/v${finalAttrs.version}/charrua-${finalAttrs.version}.tbz";
    hash = "sha256-SiUHFvgf9yTCRh7SuqNB8IjNcGqyu2CXNIN5QzBp4ss=";
  };

  propagatedBuildInputs = [
    cstruct
    fmt
    ipaddr
    macaddr
    ohex
  ];

  doCheck = true;

  meta = {
    description = "DHCP wire frame encoder and decoder";
    homepage = "https://github.com/mirage/charrua";
    changelog = "https://github.com/mirage/charrua/blob/v${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.stepbrobd ];
  };
})
