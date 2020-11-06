{ lib, fetchurl, buildDunePackage
, lwt, mirage-device, mirage-flow
}:

buildDunePackage rec {
  pname = "mirage-console";
  version = "3.0.2";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/mirage-console/releases/download/v${version}/mirage-console-v${version}.tbz";
    sha256 = "1fygk7pvlmwx6vd0h4cv9935xxhi64k2dgym41wf6qfkxgpp31lm";
  };

  propagatedBuildInputs = [ lwt mirage-device mirage-flow ];

  meta = {
    description = "Implementations of Mirage console devices";
    homepage = "https://github.com/mirage/mirage-console";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
