{stdenv, fetchurl, ocaml, findlib}:
stdenv.mkDerivation {

  name = "ocaml-csv-1.3.3";

  src = fetchurl {
    url = "https://forge.ocamlcore.org/frs/download.php/1376/csv-1.3.3.tar.gz";
    sha256 = "19qsvw3n7k4xpy0sw7n5s29kzj91myihjljhr5js6xcxwj4cydh2";
  };

  buildInputs = [ ocaml findlib ];

  createFindlibDestdir = true;

  configurePhase = "ocaml setup.ml -configure --prefix $out";

  buildPhase = "ocaml setup.ml -build";

  installPhase = "ocaml setup.ml -install";

  meta = {
    description = "A pure OCaml library to read and write CSV files";
    homepage = "https://forge.ocamlcore.org/projects/csv/";
    license = stdenv.lib.licenses.lgpl21;
    platforms = ocaml.meta.platforms;
  };
}
