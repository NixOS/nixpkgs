{
  lib,
  fetchurl,
  buildDunePackage,
  dune-configurator,
  alcotest,
}:

buildDunePackage (finalAttrs: {
  pname = "iomux";
  version = "0.4";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/haesbaert/ocaml-iomux/releases/download/v${finalAttrs.version}/iomux-${finalAttrs.version}.tbz";
    hash = "sha256-Hjk/rlWUdoSMXHBSUHaxEHDoBqVJ7rrghLBGqXcrqzU=";
  };

  buildInputs = [
    dune-configurator
  ];

  checkInputs = [
    alcotest
  ];

  meta = {
    homepage = "https://github.com/haesbaert/ocaml-iomux";
    description = "IO Multiplexers for OCaml";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ toastal ];
  };
})
