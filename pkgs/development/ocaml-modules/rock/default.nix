{ lib, fetchurl, buildDunePackage
, bigstringaf
, hmap
, httpaf
, lwt
, sexplib0
}:

buildDunePackage rec {
  pname = "rock";
  version = "0.20.0";
  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/rgrinberg/opium/releases/download/${version}/opium-${version}.tbz";
    hash = "sha256-MmuRhm3pC69TX4t9Sy/yPjnZUuVzwEs8E/EFS1n/L7Y=";
  };

  propagatedBuildInputs = [
    bigstringaf
    hmap
    httpaf
    lwt
    sexplib0
  ];

  meta = {
    description = "Minimalist framework to build extensible HTTP servers and clients";
    homepage = "https://github.com/rgrinberg/opium";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
