{
  lib,
  buildDunePackage,
  fetchurl,
  lwt,
}:

buildDunePackage (finalAttrs: {
  minimalOCamlVersion = "4.08";

  pname = "mirage-time";
  version = "3.0.0";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-time/releases/download/v${finalAttrs.version}/mirage-time-v${finalAttrs.version}.tbz";
    hash = "sha256-DUCUm1jix+i3YszIzgZjRQRiM8jJXQ49F6JC/yicvXw=";
  };

  propagatedBuildInputs = [ lwt ];

  meta = {
    homepage = "https://github.com/mirage/mirage-time";
    description = "Time operations for MirageOS";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
})
