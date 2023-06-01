{ lib
, buildDunePackage
, cstruct
, dune-configurator
, fetchurl
, fmt
, optint
, mdx
}:

buildDunePackage rec {
  pname = "uring";
  version = "0.6";

  minimalOCamlVersion = "4.12";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/ocaml-${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    sha256 = "ZltD9JnF1lJs0xjWwFXBfWMP8e5XRhCaB2P4iqHFreo=";
  };

  propagatedBuildInputs = [
    cstruct
    fmt
    optint
  ];

  buildInputs = [
    dune-configurator
  ];

  checkInputs = [
    mdx
  ];

  nativeCheckInputs = [
    mdx.bin
  ];

  doCheck = true;

  dontStrip = true;

  meta = {
    homepage = "https://github.com/ocaml-multicore/ocaml-${pname}";
    changelog = "https://github.com/ocaml-multicore/ocaml-${pname}/raw/v${version}/CHANGES.md";
    description = "Bindings to io_uring for OCaml";
    license = with lib.licenses; [ isc mit ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ toastal ];
  };
}
