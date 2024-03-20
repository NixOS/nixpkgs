{ lib
, buildDunePackage
, fetchurl
, fmt
, gmap
, ppx_deriving
, ptime
, re
, uri
}:

buildDunePackage rec {
  pname = "icalendar";
  version = "0.1.7";

  minimalOCamlVersion = "4.08.0";

  src = fetchurl {
    url =
      "https://github.com/robur-coop/${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    sha256 = "4f88b5b211fb8e84c54ead56a2c50a134987e23b9cff418dcd289a6cfc1c25f5";
  };

  propagatedBuildInputs = [ fmt gmap ppx_deriving ptime re uri ];

  meta = {
    description =
      "A library to parse and print the iCalendar (RFC 5545) format";
    homepage = "https://github.com/robur-coop/icalendar";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ ehmry ];
  };
}
