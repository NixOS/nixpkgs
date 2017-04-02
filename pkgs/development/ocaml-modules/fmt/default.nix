{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg, cmdliner, result, uchar }:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-fmt-0.8.2";

  src = fetchurl {
    url = http://erratique.ch/software/fmt/releases/fmt-0.8.2.tbz;
    sha256 = "020qz74cm65bzrywf6kylm93gr5x1ayl6hfmxaql995f6whb388i";
  };

  unpackCmd = "tar xjf $src";

  buildInputs = [ ocaml findlib ocamlbuild opam topkg cmdliner ];
  propagatedBuildInputs = [ result uchar ];

  inherit (topkg) buildPhase installPhase;

  createFindlibDestdir = true;

  meta = {
    homepage = http://erratique.ch/software/fmt;
    license = stdenv.lib.licenses.isc;
    description = "OCaml Format pretty-printer combinators";
    inherit (ocaml.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };
}
