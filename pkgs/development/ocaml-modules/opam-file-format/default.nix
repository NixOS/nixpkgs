{ stdenv, fetchFromGitHub, ocaml, findlib }:

stdenv.mkDerivation rec {
  version = "2.0.0";
  name = "ocaml${ocaml.version}-opam-file-format-${version}";

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "opam-file-format";
    rev = "${version}";
    sha256 = "0fqb99asnair0043hhc8r158d6krv5nzvymd0xwycr5y72yrp0hv";
  };

  buildInputs = [ ocaml findlib ];

  installFlags = [ "LIBDIR=$(OCAMLFIND_DESTDIR)" ];

  meta = {
    description = "Parser and printer for the opam file syntax";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
    inherit (ocaml.meta) platforms;
  };
}
