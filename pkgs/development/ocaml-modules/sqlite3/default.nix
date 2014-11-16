{stdenv, fetchurl, sqlite, ocaml, findlib, pkgconfig}:

stdenv.mkDerivation {
  name = "ocaml-sqlite3-2.0.7";

  src = fetchurl {
    url = https://github.com/mmottl/sqlite3-ocaml/archive/v2.0.7.tar.gz;
    sha256 = "04m7qz251m6l2b7slkgml2j8bnx60lwzbdbsv95vidwzqcwg7bdq";
  };

  buildInputs = [ocaml findlib pkgconfig sqlite];

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
