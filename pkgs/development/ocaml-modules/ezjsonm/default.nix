{ lib, fetchurl, buildDunePackage, jsonm, hex, sexplib0 }:

buildDunePackage rec {
  pname = "ezjsonm";
  version = "1.2.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/ezjsonm/releases/download/v${version}/ezjsonm-v${version}.tbz";
    sha256 = "1q6cf63cc614lr141rzhm2w4rhi1snfqai6fmkhvfjs84hfbw2w7";
  };

  propagatedBuildInputs = [ jsonm hex sexplib0 ];

  meta = {
    description = "An easy interface on top of the Jsonm library";
    homepage = "https://github.com/mirage/ezjsonm";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ vbgl ];
  };
}
