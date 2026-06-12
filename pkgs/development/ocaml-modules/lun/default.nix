{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage (finalAttrs: {
  pname = "lun";
  version = "0.0.3";

  minimalOCamlVersion = "4.12.0";

  src = fetchurl {
    url = "https://github.com/robur-coop/lun/releases/download/v${finalAttrs.version}/lun-${finalAttrs.version}.tbz";
    hash = "sha256-d/LIzil/ecCQffPyk2e7Iy6zOD9sfOhk2jsSLENUp0U=";
  };

  meta = {
    description = "Optics in OCaml";
    homepage = "https://github.com/robur-coop/lun";
    license = lib.licenses.isc;
    maintainers = [ ];
    hasNoMaintainersButDependents = true;
  };
})
