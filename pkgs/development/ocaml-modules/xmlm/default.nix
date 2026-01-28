{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  findlib,
  ocamlbuild,
  topkg,
}:
stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-${pname}-${version}";
  pname = "xmlm";
  version = "1.4.0";

  src = fetchurl {
    url = "https://erratique.ch/software/xmlm/releases/xmlm-${version}.tbz";
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
    broken = lib.versionOlder ocaml.version "4.05";
  };
}
