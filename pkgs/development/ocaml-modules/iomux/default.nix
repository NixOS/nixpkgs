{
  lib,
  fetchurl,
  buildDunePackage,
  dune-configurator,
  alcotest,
}:

buildDunePackage rec {
  pname = "iomux";
  version = "0.4";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/haesbaert/ocaml-${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    hash = "sha256-Hjk/rlWUdoSMXHBSUHaxEHDoBqVJ7rrghLBGqXcrqzU=";
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
