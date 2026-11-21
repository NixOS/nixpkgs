{
  buildDunePackage,
  ocsipersist,
  logs,
  sqlite3,
}:

buildDunePackage {
  pname = "ocsipersist-sqlite";
  inherit (ocsipersist) version src;

  propagatedBuildInputs = [
    logs
    sqlite3
    ocsipersist
  ];

  meta = ocsipersist.meta // {
    description = "Persistent key/value storage for OCaml using SQLite";
  };
}
