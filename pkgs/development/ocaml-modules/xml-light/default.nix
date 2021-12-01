{ stdenv, lib, fetchFromGitHub, ocaml, findlib }:
let
  pname = "xml-light";
  version = "2.4";
in
stdenv.mkDerivation {
  name = "ocaml-${pname}-${version}";

  src = fetchFromGitHub {
    owner = "ncannasse";
    repo = "xml-light";
    rev = version;
    sha256 = "sha256-2txmkl/ZN5RGaLQJmr+orqwB4CbFk2RpLJd4gr7kPiE=";
  };

  buildInputs = [ ocaml findlib ];

  createFindlibDestdir = true;

  buildPhase = ''
    make all
    make opt
  '';

  installPhase = ''
    make install_ocamlfind
    mkdir -p $out/share
    cp -vai doc $out/share/
  '';

  meta = {
    description = "Minimal Xml parser and printer for OCaml";
    longDescription = ''
      Xml-Light provides functions to parse an XML document into an OCaml
      data structure, work with it, and print it back to an XML
      document. It support also DTD parsing and checking, and is
      entirely written in OCaml, hence it does not require additional C
      library.
    '';
    homepage = "http://tech.motion-twin.com/xmllight.html";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.romildo ];
    platforms = ocaml.meta.platforms or [ ];
  };
}
