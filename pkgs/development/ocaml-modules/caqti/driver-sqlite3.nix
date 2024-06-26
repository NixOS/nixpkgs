{
  lib,
  buildDunePackage,
  caqti,
  ocaml_sqlite3,
  alcotest,
}:

buildDunePackage {
  pname = "caqti-driver-sqlite3";
  inherit (caqti) version src;

  propagatedBuildInputs = [
    caqti
    ocaml_sqlite3
  ];

  checkInputs = [ alcotest ];

  doCheck = true;

  meta = caqti.meta // {
    description = "Sqlite3 driver for Caqti using C bindings";
  };
}
