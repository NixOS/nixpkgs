{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg, cmdliner, result, uchar }:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-fmt-0.8.4";

  src = fetchurl {
    url = http://erratique.ch/software/fmt/releases/fmt-0.8.4.tbz;
    sha256 = "1qilsbisqqhmn8b1ar9lvjbgz8vf4gmqwqjnnjzgld2a3gmh8qvv";
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
