{
  buildDunePackage,
  ocsipersist,
  logs,
  pgocaml,
  xml-light,
}:

buildDunePackage {
  pname = "ocsipersist-pgsql";
  inherit (ocsipersist) version src;

  propagatedBuildInputs = [
    logs
    ocsipersist
    pgocaml
  ];

  meta = ocsipersist.meta // {
    description = "Persistent key/value storage for OCaml using PostgreSQL";
  };
}
