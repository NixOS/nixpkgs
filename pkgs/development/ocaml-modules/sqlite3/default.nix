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
  version = "5.3.1";
  duneVersion = "3";
  minimalOCamlVersion = "4.12";

  src = fetchurl {
    url = "https://github.com/mmottl/sqlite3-ocaml/releases/download/${version}/sqlite3-${version}.tbz";
    hash = "sha256-Ox8eZS4r6PbJh8nei52ftUyf25SKwIUMi5UEv4L+6mE=";
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
      vbgl
    ];
  };
}
