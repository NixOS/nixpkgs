{ lib, buildDunePackage, caqti, ocaml_sqlite3 }:

buildDunePackage {
  pname = "caqti-driver-sqlite3";
  useDune2 = true;
  inherit (caqti) version src;

  propagatedBuildInputs = [ caqti ocaml_sqlite3 ];

  meta = caqti.meta // {
    description = "Sqlite3 driver for Caqti using C bindings";
  };
}
