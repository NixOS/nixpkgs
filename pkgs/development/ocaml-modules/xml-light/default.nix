{stdenv, fetchurl, ocaml, findlib}:
let
  pname = "xml-light";
  version = "2.4";
in
stdenv.mkDerivation {
  name = "ocaml-${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/ncannasse/${pname}/archive/${version}.tar.gz";
    sha256 = "10b55qf6mvdp11ny3h0jv6k6wrs78jr9lhsiswl0xya7z8r8j0a2";
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
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.romildo ];
    platforms = ocaml.meta.platforms or [];
  };
}
