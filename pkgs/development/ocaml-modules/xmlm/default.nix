{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg }:
let
  pname = "xmlm";
  webpage = "https://erratique.ch/software/${pname}";
in

if !lib.versionAtLeast ocaml.version "4.02"
then throw "xmlm is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-${pname}-${version}";
  version = "1.3.0";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "1rrdxg5kh9zaqmgapy9bhdqyxbbvxxib3bdfg1vhw4rrkp1z0x8n";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild topkg ];
  buildInputs = [ topkg ];

  strictDeps = true;

  inherit (topkg) buildPhase installPhase;

  meta = with lib; {
    description = "An OCaml streaming codec to decode and encode the XML data format";
    homepage = webpage;
    platforms = ocaml.meta.platforms or [];
    maintainers = [ maintainers.vbgl ];
    license = licenses.bsd3;
  };
}
