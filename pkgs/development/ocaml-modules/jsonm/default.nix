{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, opam, uutf }:

let version = "1.0.1"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-jsonm-${version}";

  src = fetchurl {
    url = "http://erratique.ch/software/jsonm/releases/jsonm-${version}.tbz";
    sha256 = "1176dcmxb11fnw49b7yysvkjh0kpzx4s48lmdn5psq9vshp5c29w";
  };

  buildInputs = [ ocaml findlib ocamlbuild topkg opam ];
  propagatedBuildInputs = [ uutf ];

  unpackCmd = "tar xjf $src";

  createFindlibDestdir = true;

  inherit (topkg) buildPhase installPhase;

  meta = {
    description = "An OCaml non-blocking streaming codec to decode and encode the JSON data format";
    homepage = http://erratique.ch/software/jsonm;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
