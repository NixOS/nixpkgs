{ stdenv, lib, fetchpatch, fetchFromGitHub, ocaml, findlib }:

stdenv.mkDerivation rec {
  version = "2.1.2";
  name = "ocaml${ocaml.version}-opam-file-format-${version}";

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "opam-file-format";
    rev = version;
    sha256 = "19xppn2s3yjid8jc1wh8gdf5mgmlpzby2cf2slmnbyrgln3vj6i2";
  };

  buildInputs = [ ocaml findlib ];

  installFlags = [ "LIBDIR=$(OCAMLFIND_DESTDIR)" ];

  patches = [
    ./optional-static.patch
    # fix no implementation error for OpamParserTypes
    # can be removed at next release presumably
    (fetchpatch {
      url = "https://github.com/ocaml/opam-file-format/pull/41/commits/2a9a92ec334e0bf2adf8d2b4c1b83f1f9f68df8f.patch";
      sha256 = "090nl7yciyyidmbjfryw3wyx7srh6flnrr4zgyhv4kvjsvq944y2";
    })
  ];

  meta = {
    description = "Parser and printer for the opam file syntax";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
    inherit (ocaml.meta) platforms;
  };
}
