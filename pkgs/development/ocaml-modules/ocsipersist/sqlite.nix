{
  buildDunePackage,
  ocsipersist,
  logs,
  ocaml_sqlite3,
  ocsigen_server,
}:

buildDunePackage {
  pname = "ocsipersist-sqlite";
  inherit (ocsipersist) version src;

  propagatedBuildInputs = [
    logs
    ocaml_sqlite3
    ocsipersist
  ];

  meta = ocsipersist.meta // {
    description = "Persistent key/value storage for OCaml using SQLite";
  };
}
