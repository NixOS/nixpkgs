{ stdenv, fetchzip, ocaml, findlib }:

stdenv.mkDerivation {

  name = "ocaml-csv-1.4.1";

  src = fetchzip {
    url = https://github.com/Chris00/ocaml-csv/releases/download/1.4.1/csv-1.4.1.tar.gz;
    sha256 = "1z38qy92lq8qh91bs70vsv868szainif53a2y6rf47ijdila25j4";
  };

  buildInputs = [ ocaml findlib ];

  createFindlibDestdir = true;

  configurePhase = "ocaml setup.ml -configure --prefix $out --enable-tests";

  buildPhase = "ocaml setup.ml -build";

  doCheck = true;
  checkPhase = "ocaml setup.ml -test";

  installPhase = "ocaml setup.ml -install";

  meta = with stdenv.lib; {
    description = "A pure OCaml library to read and write CSV files";
    homepage = https://github.com/Chris00/ocaml-csv;
    license = licenses.lgpl21;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms;
  };
}
