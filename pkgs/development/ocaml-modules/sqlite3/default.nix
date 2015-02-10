{ stdenv, fetchurl, sqlite, ocaml, findlib, pkgconfig }:

stdenv.mkDerivation {
  name = "ocaml-sqlite3-2.0.8";

  src = fetchurl {
    url = https://github.com/mmottl/sqlite3-ocaml/releases/download/v2.0.8/sqlite3-ocaml-2.0.8.tar.gz;
    sha256 = "1xalhjg5pbyad6b8cijq7fm5ss7ipjz68hzycggac58rnshwn2ix";
  };

  buildInputs = [ ocaml findlib pkgconfig sqlite ];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = http://mmottl.github.io/sqlite3-ocaml/;
    description = "OCaml bindings to the SQLite 3 database access library";
    license = licenses.mit;
    platforms = ocaml.meta.platforms;
    maintainers = with maintainers; [
      z77z vbgl
    ];
  };
}
