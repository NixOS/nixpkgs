{
  lib,
  buildDunePackage,
  fetchurl,
  containers,
}:

buildDunePackage rec {
  pname = "decoders";
  version = "1.0.0";

  minimalOCamlVersion = "4.03.0";

  src = fetchurl {
    url = "https://github.com/mattjbray/ocaml-decoders/releases/download/v${version}/${pname}-${version}.tbz";
    hash = "sha256-R/55xBAtD3EO/zzq7zExANnfPHlFg00884o5dCpXNZc=";
  };

  doCheck = true;
  checkInputs = [
    containers
  ];

  meta = {
    description = "Elm-inspired decoders for Ocaml";
    homepage = "https://github.com/mattjbray/ocaml-decoders";
    changelog = "https://github.com/mattjbray/ocaml-decoders/blob/${version}/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ infinidoge ];
  };
}
