{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg }:

if !stdenv.lib.versionAtLeast ocaml.version "4.3"
then throw "digestif is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-digestif-${version}";
  version = "0.5";

  src = fetchurl {
    url = "https://github.com/mirage/digestif/releases/download/v${version}/digestif-${version}.tbz";
    sha256 = "0fsyfi5ps17j3wjav5176gf6z3a5xcw9aqhcr1gml9n9ayfbkhrd";
  };

  buildInputs = [ ocaml findlib ocamlbuild topkg ];

  inherit (topkg) buildPhase installPhase;

  meta = {
    description = "Simple hash algorithms in OCaml";
    homepage = "https://github.com/mirage/digestif";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
