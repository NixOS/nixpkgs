{ lib, fetchurl, buildDunePackage
, fmt
, lwt
, optint
, ptime
, alcotest
}:

buildDunePackage rec {
  pname = "mirage-kv";
  version = "6.1.1";

  duneVersion = "3";
  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-kv/releases/download/v${version}/mirage-kv-${version}.tbz";
    sha256 = "7cd5cd95a0e96f9cd4036ad3c22e61d63e2fe0b426a2fc46f809babbed60b8f4";
  };

  propagatedBuildInputs = [ fmt lwt optint ptime ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    description = "MirageOS signatures for key/value devices";
    homepage = "https://github.com/mirage/mirage-kv";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
