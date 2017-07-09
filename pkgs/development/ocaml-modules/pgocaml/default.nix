{ stdenv, fetchurl, buildOcaml, ocaml, calendar, csv, re }:

if !stdenv.lib.versionAtLeast ocaml.version "4"
then throw "pgocaml is not available for OCaml ${ocaml.version}"
else

buildOcaml {
  name = "pgocaml";
  version = "2.3";
  src = fetchurl {
    url = https://github.com/darioteixeira/pgocaml/archive/v2.3.tar.gz;
    sha256 = "18lymxlvcf4nwxawkidq3pilsp5rhl0l8ifq6pjk3ssjlx9w53pg";
  };

  buildInputs = [ ];
  propagatedBuildInputs = [ calendar csv re ];

  configureFlags = [ "--enable-p4" ];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    description = "An interface to PostgreSQL databases for OCaml applications";
    homepage = http://pgocaml.forge.ocamlcore.org/;
    license = licenses.lgpl2;
    maintainers = with maintainers; [ vbgl ];
  };
}
