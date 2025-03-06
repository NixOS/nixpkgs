{
  lib,
  fetchurl,
  sqlite,
  pkg-config,
  buildDunePackage,
  dune-configurator,
}:

buildDunePackage rec {
  pname = "sqlite3";
  version = "5.3.0";
  duneVersion = "3";
  minimalOCamlVersion = "4.12";

  src = fetchurl {
    url = "https://github.com/mmottl/sqlite3-ocaml/releases/download/${version}/sqlite3-${version}.tbz";
    hash = "sha256-+XuR3ovI5soNXMNgTxYcEbx26lV+3i7q8XaKCI6ueAo=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    dune-configurator
    sqlite
  ];

  meta = with lib; {
    homepage = "http://mmottl.github.io/sqlite3-ocaml/";
    description = "OCaml bindings to the SQLite 3 database access library";
    license = licenses.mit;
    maintainers = with maintainers; [
      maggesi
      vbgl
    ];
  };
}
