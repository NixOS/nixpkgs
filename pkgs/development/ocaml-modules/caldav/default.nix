{ lib
, buildDunePackage
, fetchurl
, cohttp
, cohttp-lwt
, dispatch
, hex
, icalendar
, lwt
, metrics
, mirage-clock
, mirage-crypto-rng
, mirage-kv
, mirage-random
, ppx_deriving
, ptime
, sexplib
, tyxml
, xmlm
}:

buildDunePackage rec {
  pname = "caldav";
  version = "0.2.1";

  minimalOCamlVersion = "4.08.0";

  src = fetchurl {
    url =
      "https://github.com/robur-coop/${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    sha256 = "5cc85adbf892ea676e67a2451d12cabd930fba45f534bced7e7b00e2d282ddba";
  };

  propagatedBuildInputs = [
    cohttp
    cohttp-lwt
    dispatch
    hex
    icalendar
    lwt
    metrics
    mirage-clock
    mirage-crypto-rng
    mirage-kv
    mirage-random
    ppx_deriving
    ptime
    sexplib
    tyxml
    xmlm
  ];

  meta = {
    description = "A CalDAV server";
    homepage = "https://github.com/robur-coop/caldav";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ ehmry ];
  };
}
