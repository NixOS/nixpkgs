{ lib, fetchurl, buildDunePackage
, lwt, mirage-device, mirage-flow
}:

buildDunePackage rec {
  pname = "mirage-console";
  version = "4.0.0";

  minimumOCamlVersion = "4.08";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/mirage-console/releases/download/v${version}/mirage-console-v${version}.tbz";
    sha256 = "11nwfd4kmmdzkrkhbakdi3cxhk8vi98l17960rgcf85c602gw6vp";
  };

  propagatedBuildInputs = [ lwt mirage-device mirage-flow ];

  meta = {
    description = "Implementations of Mirage console devices";
    homepage = "https://github.com/mirage/mirage-console";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
