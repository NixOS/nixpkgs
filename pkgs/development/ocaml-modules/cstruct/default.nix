{ stdenv, fetchurl, ocaml, dune, findlib, sexplib, ocplib-endian }:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-cstruct-${version}";
  version = "3.1.1";
  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cstruct/releases/download/v${version}/cstruct-${version}.tbz";
    sha256 = "1x4jxsvd1lrfibnjdjrkfl7hqsc48rljnwbap6faanj9qhwwa6v2";
  };

  unpackCmd = "tar -xjf $curSrc";

  buildInputs = [ ocaml dune findlib ];

  propagatedBuildInputs = [ sexplib ocplib-endian ];

  buildPhase = "dune build -p cstruct";

  inherit (dune) installPhase;

  meta = {
    description = "Access C-like structures directly from OCaml";
    license = stdenv.lib.licenses.isc;
    homepage = "https://github.com/mirage/ocaml-cstruct";
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
