{ lib, buildDunePackage, ocaml, fetchurl, alcotest, fmt }:

buildDunePackage rec {
  pname = "gmap";
  version = "0.3.0";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/hannesm/gmap/releases/download/${version}/gmap-${version}.tbz";
    sha256 = "073wa0lrb0jj706j87cwzf1a8d1ff14100mnrjs8z3xc4ri9xp84";
  };

  minimalOCamlVersion = "4.03";

  checkInputs = [ alcotest fmt ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = {
    description = "Heterogenous maps over a GADT";
    homepage = "https://github.com/hannesm/gmap";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
