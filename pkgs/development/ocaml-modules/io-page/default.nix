{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, cstruct }:

let version = "1.5.1"; in

stdenv.mkDerivation {
  name = "ocaml-io-page-${version}";

  src = fetchzip {
    url = "https://github.com/mirage/io-page/archive/v${version}.tar.gz";
    sha256 = "0y92wbvi129d0i7wr4lpk1ps9l247zaf1ibqqz0i6spgl28dyq79";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];
  propagatedBuildInputs = [ cstruct ];

  createFindlibDestdir = true;

  meta = {
    homepage = https://github.com/mirage/io-page;
    platforms = ocaml.meta.platforms or [];
    description = "IO memory page library for Mirage backends";
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
