{ lib, fetchurl, sqlite, pkgconfig, buildDunePackage }:

buildDunePackage rec {
  pname = "sqlite3";
  version = "5.0.2";
  minimumOCamlVersion = "4.05";

  src = fetchurl {
    url = "https://github.com/mmottl/sqlite3-ocaml/releases/download/${version}/sqlite3-${version}.tbz";
    sha256 = "0sba74n0jvzxibrclhbpqscil36yfw7i9jj9q562yhza6rax9p82";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ sqlite ];

  meta = with lib; {
    homepage = "http://mmottl.github.io/sqlite3-ocaml/";
    description = "OCaml bindings to the SQLite 3 database access library";
    license = licenses.mit;
    maintainers = with maintainers; [
      maggesi vbgl
    ];
  };
}
