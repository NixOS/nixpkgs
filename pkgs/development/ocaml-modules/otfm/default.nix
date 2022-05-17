{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, uutf, result }:

let
  pname = "otfm";
  version = "0.3.0";
  webpage = "https://erratique.ch/software/${pname}";
in

assert lib.versionAtLeast ocaml.version "4.01.0";

stdenv.mkDerivation {

  name = "ocaml-${pname}-${version}";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "054s82539k3kc9na6s47g3scsl04icjahpas7pv5351jmsgqcq3k";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild topkg ];
  buildInputs = [ topkg ];

  propagatedBuildInputs = [ uutf result ];

  strictDeps = true;

  inherit (topkg) buildPhase installPhase;

  meta = with lib; {
    description = "OpenType font decoder for OCaml";
    longDescription = ''
      Otfm is an in-memory decoder for the OpenType font data format. It
      provides low-level access to font tables and functions to decode some
      of them.
    '';
    homepage = webpage;
    license = licenses.bsd3;
    maintainers = [ maintainers.jirkamarsik ];
    mainProgram = "otftrip";
    inherit (ocaml.meta) platforms;
  };
}
