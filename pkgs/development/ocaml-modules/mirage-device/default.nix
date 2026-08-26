{
  lib,
  buildDunePackage,
  fetchurl,
  fmt,
  lwt,
}:

buildDunePackage (finalAttrs: {
  pname = "mirage-device";
  version = "2.0.0";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-device/releases/download/v${finalAttrs.version}/mirage-device-v${finalAttrs.version}.tbz";
    hash = "sha256-BChsZyjygM9uxT3FTmfVUrE3XVtUSkXJ2rhTbqLvVKE=";
  };

  propagatedBuildInputs = [
    fmt
    lwt
  ];

  meta = {
    description = "Abstract devices for MirageOS";
    homepage = "https://github.com/mirage/mirage-device";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
