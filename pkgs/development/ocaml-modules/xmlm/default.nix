{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  findlib,
  ocamlbuild,
  topkg,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "ocaml${ocaml.version}-${finalAttrs.pname}-${finalAttrs.version}";
  pname = "xmlm";
  version = "1.4.0";

  src = fetchurl {
    url = "https://erratique.ch/software/xmlm/releases/xmlm-${finalAttrs.version}.tbz";
    sha256 = "sha256-CRJSJY490WMgw85N2yG81X79nIwuv7eZ7mpUPtSS2fo=";
  };

  nativeBuildInputs = [
    ocaml
    findlib
    ocamlbuild
    topkg
  ];
  buildInputs = [ topkg ];

  strictDeps = true;

  inherit (topkg) buildPhase installPhase;

  meta = {
    description = "OCaml streaming codec to decode and encode the XML data format";
    homepage = "https://erratique.ch/software/xmlm";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "xmltrip";
    inherit (ocaml.meta) platforms;
  };
})
