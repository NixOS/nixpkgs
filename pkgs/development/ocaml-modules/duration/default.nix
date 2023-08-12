{ lib, buildDunePackage, ocaml, fetchurl, alcotest }:

buildDunePackage rec {
  pname = "duration";
  version = "0.2.1";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/hannesm/duration/releases/download/v${version}/duration-${version}.tbz";
    hash = "sha256-xzjB84z7mYIMEhzT3fgZ3ksiKPDVDqy9HMPOmefHHis=";
  };

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ alcotest ];

  meta = {
    homepage = "https://github.com/hannesm/duration";
    description = "Conversions to various time units";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
