{stdenv, fetchurl, ocaml, findlib, camlp4, calendar, csv, ocaml_pcre}:

stdenv.mkDerivation {
  name = "ocaml-pgocaml-2.1";
  src = fetchurl {
    url = http://forge.ocamlcore.org/frs/download.php/1413/pgocaml-2.1.tgz;
    sha256 = "0m7whlmhm7z58pfaarvkyiwaylmrz05aj6fr773zd9xlv07ljiym";
  };

  buildInputs = [ocaml findlib camlp4];
  propagatedBuildInputs = [calendar csv ocaml_pcre];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    description = "An interface to PostgreSQL databases for OCaml applications";
    homepage = http://pgocaml.forge.ocamlcore.org/;
    license = licenses.lgpl2;
    platforms = ocaml.meta.platforms;
    maintainers = with maintainers; [ vbgl ];
  };
}
