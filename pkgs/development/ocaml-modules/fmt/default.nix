{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg, cmdliner }:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-fmt-0.8.0";

  src = fetchurl {
    url = http://erratique.ch/software/fmt/releases/fmt-0.8.0.tbz;
    sha256 = "16y7ibndnairb53j8a6qgipyqwjxncn4pl9jiw5bxjfjm59108px";
  };

  unpackCmd = "tar xjf $src";

  buildInputs = [ ocaml findlib ocamlbuild opam topkg cmdliner ];

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
