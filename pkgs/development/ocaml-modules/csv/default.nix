{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, ocaml_lwt }:

let param =
  if stdenv.lib.versionAtLeast ocaml.version "4.2"
  then {
    version = "1.7";
    url = https://github.com/Chris00/ocaml-csv/releases/download/1.7/csv-1.7.tar.gz;
    sha256 = "0696jg3404kq1x97lxvy6r82ldsryycd7lbckp9vyq4myn736zhh";
    lwtSupport = true;
  } else {
    version = "1.5";
    url = https://github.com/Chris00/ocaml-csv/releases/download/1.5/csv-1.5.tar.gz;
    sha256 = "1ca7jgg58j24pccs5fshis726s06fdcjshnwza5kwxpjgdbvc63g";
    lwtSupport = false;
  };
in

stdenv.mkDerivation {

  name = "ocaml${ocaml.version}-csv-${param.version}";

  src = fetchzip {
    inherit (param) url sha256;
  };

  buildInputs = [ ocaml findlib ocamlbuild ]
  ++ stdenv.lib.optional param.lwtSupport ocaml_lwt;

  createFindlibDestdir = true;

  configurePhase = "ocaml setup.ml -configure --prefix $out --enable-tests"
  + stdenv.lib.optionalString param.lwtSupport " --enable-lwt";

  buildPhase = "ocaml setup.ml -build";

  doCheck = true;
  checkPhase = "ocaml setup.ml -test";

  installPhase = "ocaml setup.ml -install";

  meta = with stdenv.lib; {
    description = "A pure OCaml library to read and write CSV files";
    homepage = https://github.com/Chris00/ocaml-csv;
    license = licenses.lgpl21;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
