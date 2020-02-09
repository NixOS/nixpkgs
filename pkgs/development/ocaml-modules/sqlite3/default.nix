{ lib, fetchurl, sqlite, pkgconfig, buildDunePackage }:

buildDunePackage rec {
  pname = "sqlite3";
  version = "5.0.1";
  minimumOCamlVersion = "4.05";

  src = fetchurl {
    url = "https://github.com/mmottl/sqlite3-ocaml/releases/download/${version}/sqlite3-${version}.tbz";
    sha256 = "0iymkszrs6qwak0vadfzc8yd8jfwn06zl08ggb4jr2mgk2c8mmsn";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ sqlite ];

  meta = with lib; {
    homepage = http://mmottl.github.io/sqlite3-ocaml/;
    description = "OCaml bindings to the SQLite 3 database access library";
    license = licenses.mit;
    maintainers = with maintainers; [
      maggesi vbgl
    ];
  };
}
