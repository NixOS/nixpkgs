{ lib
, fetchurl
, buildDunePackage
, dune-configurator
, alcotest
}:

buildDunePackage rec {
  pname = "iomux";
  version = "0.3";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/haesbaert/ocaml-${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    sha256 = "zNJ3vVOv0BEpHLiC8Y610F87uiMlfYNo28ej0H+EU+c=";
  };

  buildInputs = [
    dune-configurator
  ];

  checkInputs = [
    alcotest
  ];

  meta = {
    homepage = "https://github.com/haesbaert/ocaml-${pname}";
    description = "IO Multiplexers for OCaml";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ toastal ];
  };
}
