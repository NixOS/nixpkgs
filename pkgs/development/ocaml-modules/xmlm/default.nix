{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  findlib,
  ocamlbuild,
  topkg,
}:
let
  pname = "xmlm";
  webpage = "https://erratique.ch/software/${pname}";
in

if lib.versionOlder ocaml.version "4.05" then
  throw "xmlm is not available for OCaml ${ocaml.version}"
else

  stdenv.mkDerivation rec {
    name = "ocaml${ocaml.version}-${pname}-${version}";
    version = "1.4.0";

    src = fetchurl {
      url = "${webpage}/releases/${pname}-${version}.tbz";
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

    meta = with lib; {
      description = "OCaml streaming codec to decode and encode the XML data format";
      homepage = webpage;
      license = licenses.isc;
      maintainers = [ maintainers.vbgl ];
      mainProgram = "xmltrip";
      inherit (ocaml.meta) platforms;
    };
  }
