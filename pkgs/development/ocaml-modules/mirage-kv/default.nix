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

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-kv/releases/download/v${version}/mirage-kv-${version}.tbz";
    hash = "sha256-fNXNlaDpb5zUA2rTwi5h1j4v4LQmovxG+Am6u+1guPQ=";
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
