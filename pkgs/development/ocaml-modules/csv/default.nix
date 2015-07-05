{ stdenv, fetchzip, ocaml, findlib }:

stdenv.mkDerivation {

  name = "ocaml-csv-1.4";

  src = fetchzip {
    url = https://github.com/Chris00/ocaml-csv/releases/download/1.4/csv-1.4.tar.gz;
    sha256 = "0si0v79rxzyzmgyhd6lidpzxdlcpprlhg0pgrsf688g83xsclkwa";
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
