{
  lib,
  fetchurl,
  buildDunePackage,
  lwt,
  mirage-flow,
}:

buildDunePackage (finalAttrs: {
  pname = "mirage-console";
  version = "5.1.0";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-console/releases/download/v${finalAttrs.version}/mirage-console-${finalAttrs.version}.tbz";
    hash = "sha256-mjYRisbNOJbYoSuWaGoPueXakmqAwmWh0ATvLLsvpNM=";
  };

  propagatedBuildInputs = [
    lwt
    mirage-flow
  ];

  meta = {
    description = "Implementations of Mirage console devices";
    homepage = "https://github.com/mirage/mirage-console";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
