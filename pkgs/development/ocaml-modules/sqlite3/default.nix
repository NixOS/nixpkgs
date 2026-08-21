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
  version = "5.4.2";
  duneVersion = "3";
  minimalOCamlVersion = "4.12";

  src = fetchurl {
    url = "https://github.com/mmottl/sqlite3-ocaml/releases/download/${version}/sqlite3-${version}.tbz";
    hash = "sha256-MvaPB49L6u1R68J5/vRhRSBf2Yz2x5/pVSGGAfICYhw=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    dune-configurator
    sqlite
  ];

  meta = {
    homepage = "http://mmottl.github.io/sqlite3-ocaml/";
    description = "OCaml bindings to the SQLite 3 database access library";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      vbgl
    ];
  };
}
