{ stdenv, fetchzip, ocaml, findlib, cstruct }:

let version = "1.4.0"; in

stdenv.mkDerivation {
  name = "ocaml-io-page-${version}";

  src = fetchzip {
    url = "https://github.com/mirage/io-page/archive/v${version}.tar.gz";
    sha256 = "05m1gbcy72i6gikdijbkpw8pfygc86a3l4k8ayyl58019l6qa2fq";
  };

  buildInputs = [ ocaml findlib ];
  propagatedBuildInputs = [ cstruct ];

  createFindlibDestdir = true;

  meta = {
    homepage = https://github.com/mirage/io-page;
    platforms = ocaml.meta.platforms;
    description = "IO memory page library for Mirage backends";
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
