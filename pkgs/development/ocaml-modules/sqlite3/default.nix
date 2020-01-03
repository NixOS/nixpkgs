{ stdenv, fetchurl, sqlite, ocaml, findlib, ocamlbuild, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "ocaml-sqlite3";
  version = "2.0.9";

  src = fetchurl {
    url = "https://github.com/mmottl/sqlite3-ocaml/releases/download/v${version}/sqlite3-ocaml-${version}.tar.gz";
    sha256 = "0rwsx1nfa3xqmbygim2qx45jqm1gwf08m70wmcwkx50f1qk3l551";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ocaml findlib ocamlbuild sqlite ];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = http://mmottl.github.io/sqlite3-ocaml/;
    description = "OCaml bindings to the SQLite 3 database access library";
    license = licenses.mit;
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [
      maggesi vbgl
    ];
  };
}
