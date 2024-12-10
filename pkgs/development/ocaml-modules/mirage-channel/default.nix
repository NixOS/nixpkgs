{
  lib,
  fetchurl,
  buildDunePackage,
  cstruct,
  logs,
  lwt,
  mirage-flow,
  alcotest,
  mirage-flow-combinators,
}:

buildDunePackage rec {
  pname = "mirage-channel";
  version = "4.1.0";

  minimalOCamlVersion = "4.07";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-channel/releases/download/v${version}/mirage-channel-${version}.tbz";
    hash = "sha256-sBdoUdTd9ZeNcHK0IBGBeOYDDqULM7EYX+Pz2f2nIQA=";
  };

  propagatedBuildInputs = [
    cstruct
    logs
    lwt
    mirage-flow
  ];

  doCheck = true;
  checkInputs = [
    alcotest
    mirage-flow-combinators
  ];

  meta = {
    description = "Buffered channels for MirageOS FLOW types";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/mirage/mirage-channel";
  };
}
