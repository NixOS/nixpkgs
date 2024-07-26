{ lib, fetchurl, buildDunePackage
, fmt
, lwt
, alcotest
}:

buildDunePackage rec {
  pname = "mirage-kv";
  version = "4.0.1";

  duneVersion = "3";
  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-kv/releases/download/v${version}/mirage-kv-${version}.tbz";
    hash = "sha256-p6i4zUVgxtTnUiBIjb8W6u9xRTczVl4WwfFcl5tVqnE=";
  };

  propagatedBuildInputs = [ fmt lwt ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    description = "MirageOS signatures for key/value devices";
    homepage = "https://github.com/mirage/mirage-kv";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
