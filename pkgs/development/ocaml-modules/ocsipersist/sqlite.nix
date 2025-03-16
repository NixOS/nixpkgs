{ buildDunePackage, ocsipersist-lib
, ocsipersist
, lwt_log
, ocaml_sqlite3
, ocsigen_server
, xml-light
}:

buildDunePackage {
  pname = "ocsipersist-sqlite";
  inherit (ocsipersist-lib) version src;
  duneVersion = "3";

  propagatedBuildInputs = [
    lwt_log
    ocaml_sqlite3
    ocsigen_server
    ocsipersist-lib
    xml-light
    ocsipersist
  ];

  meta = ocsipersist-lib.meta // {
    description = "Persistent key/value storage (for Ocsigen) using SQLite";
  };
}
