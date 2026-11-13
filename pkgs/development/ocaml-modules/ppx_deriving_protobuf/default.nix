{
  lib,
  fetchurl,
  buildDunePackage,
  cppo,
  ppx_deriving,
  ppxlib,
  dune-configurator,
}:

buildDunePackage (finalAttrs: {
  pname = "ppx_deriving_protobuf";
  version = "3.0.0";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/ocaml-ppx/ppx_deriving_protobuf/releases/download/v${finalAttrs.version}/ppx_deriving_protobuf-v${finalAttrs.version}.tbz";
    hash = "sha256-UofvDbjU96YrC7eiEBAXLWAqpFp/7MLUy5aBNm3fgbU=";
  };

  nativeBuildInputs = [ cppo ];
  buildInputs = [
    ppxlib
    dune-configurator
  ];
  propagatedBuildInputs = [ ppx_deriving ];

  meta = {
    homepage = "https://github.com/ocaml-ppx/ppx_deriving_protobuf";
    description = "Protocol Buffers codec generator for OCaml";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vyorkin ];
  };
})
