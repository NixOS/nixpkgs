{ lib, fetchurl, buildDunePackage, jsonm, hex, sexplib0 }:

buildDunePackage rec {
  pname = "ezjsonm";
  version = "1.3.0";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/ezjsonm/releases/download/v${version}/ezjsonm-${version}.tbz";
    hash = "sha256-CGM+Dw52eoroGTXKfnTxaTuFp5xFAtVo7t/1Fw8M13s=";
  };

  propagatedBuildInputs = [ jsonm hex sexplib0 ];

  meta = {
    description = "An easy interface on top of the Jsonm library";
    homepage = "https://github.com/mirage/ezjsonm";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ vbgl ];
  };
}
