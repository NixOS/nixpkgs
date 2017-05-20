{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, cstruct }:

let version = "1.6.1"; in

stdenv.mkDerivation {
  name = "ocaml-io-page-${version}";

  src = fetchzip {
    url = "https://github.com/mirage/io-page/archive/v${version}.tar.gz";
    sha256 = "1djwks3ss12m55q6h4jsvfsy848cxfnpaxkilw10h26xj6jchflz";
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
