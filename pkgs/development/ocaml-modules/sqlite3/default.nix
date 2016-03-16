{ stdenv, fetchurl, sqlite, ocaml, findlib, pkgconfig }:

stdenv.mkDerivation rec {
  name = "ocaml-sqlite3-${version}";
  version = "2.0.9";

  src = fetchurl {
    url = "https://github.com/mmottl/sqlite3-ocaml/releases/download/v${version}/sqlite3-ocaml-${version}.tar.gz";
    sha256 = "0rwsx1nfa3xqmbygim2qx45jqm1gwf08m70wmcwkx50f1qk3l551";
  };

  buildInputs = [ ocaml findlib pkgconfig sqlite ];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = http://mmottl.github.io/sqlite3-ocaml/;
    description = "OCaml bindings to the SQLite 3 database access library";
    license = licenses.mit;
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    maintainers = with maintainers; [
      z77z vbgl
    ];
  };
}
