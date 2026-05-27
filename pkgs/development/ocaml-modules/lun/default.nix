{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage (finalAttrs: {
  pname = "lun";
  version = "0.0.2";

  minimalOCamlVersion = "4.12.0";

  src = fetchurl {
    url = "https://github.com/robur-coop/lun/releases/download/v${finalAttrs.version}/lun-${finalAttrs.version}.tbz";
    hash = "sha256-1oqjTXY+/jJT1uQOV6iiK9qV9DAmERYsL2BtentmB8I=";
  };

  meta = {
    description = "Optics in OCaml";
    homepage = "https://github.com/robur-coop/lun";
    license = lib.licenses.isc;
    maintainers = [ ];
  };
})
