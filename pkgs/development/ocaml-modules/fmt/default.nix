{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, cmdliner, result, uchar }:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-fmt-0.8.5";

  src = fetchurl {
    url = http://erratique.ch/software/fmt/releases/fmt-0.8.5.tbz;
    sha256 = "1zj9azcxcn6skmb69ykgmi9z8c50yskwg03wqgh87lypgjdcz060";
  };

  buildInputs = [ ocaml findlib ocamlbuild topkg cmdliner ];
  propagatedBuildInputs = [ result uchar ];

  inherit (topkg) buildPhase installPhase;

  meta = {
    homepage = http://erratique.ch/software/fmt;
    license = stdenv.lib.licenses.isc;
    description = "OCaml Format pretty-printer combinators";
    inherit (ocaml.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };
}
