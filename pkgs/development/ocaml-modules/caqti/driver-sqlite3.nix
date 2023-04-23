{ lib, buildDunePackage, caqti, ocaml_sqlite3 }:

buildDunePackage {
  pname = "caqti-driver-sqlite3";
  inherit (caqti) version src;

  duneVersion = "3";

  propagatedBuildInputs = [ caqti ocaml_sqlite3 ];

  meta = caqti.meta // {
    description = "Sqlite3 driver for Caqti using C bindings";
  };
}
