{ stdenv, fetchurl, ocaml, findlib, camlp4, calendar, csv, ocaml_pcre }:

stdenv.mkDerivation {
  name = "ocaml-pgocaml-2.2";
  src = fetchurl {
    url = http://forge.ocamlcore.org/frs/download.php/1506/pgocaml-2.2.tgz;
    sha256 = "0x0dhlz2rqxpwfdqi384f9fn0ng2irifadmxfm2b4gcz7y1cl9rh";
  };

  buildInputs = [ ocaml findlib camlp4 ];
  propagatedBuildInputs = [ calendar csv ocaml_pcre ];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    description = "An interface to PostgreSQL databases for OCaml applications";
    homepage = http://pgocaml.forge.ocamlcore.org/;
    license = licenses.lgpl2;
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    maintainers = with maintainers; [ vbgl ];
  };
}
