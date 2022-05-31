{ lib, fetchurl, buildDunePackage
, lwt, mirage-device, mirage-flow
}:

buildDunePackage rec {
  pname = "mirage-console";
  version = "5.1.0";

  minimumOCamlVersion = "4.08";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/mirage-console/releases/download/v${version}/mirage-console-${version}.tbz";
    sha256 = "sha256-mjYRisbNOJbYoSuWaGoPueXakmqAwmWh0ATvLLsvpNM=";
  };

  propagatedBuildInputs = [ lwt mirage-device mirage-flow ];

  meta = {
    description = "Implementations of Mirage console devices";
    homepage = "https://github.com/mirage/mirage-console";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
