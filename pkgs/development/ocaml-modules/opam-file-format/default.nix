{ stdenv, fetchFromGitHub, ocaml, findlib }:

stdenv.mkDerivation rec {
  version = "2.1.0";
  name = "ocaml${ocaml.version}-opam-file-format-${version}";

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "opam-file-format";
    rev = version;
    sha256 = "1772ylrlp2mrlxywv9qpdy5pmvm8594gbw98cdanbyknzvcnbz1q";
  };

  buildInputs = [ ocaml findlib ];

  installFlags = [ "LIBDIR=$(OCAMLFIND_DESTDIR)" ];

  patches = [ ./optional-static.patch ];

  meta = {
    description = "Parser and printer for the opam file syntax";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
    inherit (ocaml.meta) platforms;
  };
}
