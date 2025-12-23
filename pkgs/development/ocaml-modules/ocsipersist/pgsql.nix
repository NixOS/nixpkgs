{
  buildDunePackage,
  ocsipersist,
  lwt_log,
  pgocaml,
  xml-light,
}:

buildDunePackage {
  pname = "ocsipersist-pgsql";
  inherit (ocsipersist) version src;

  propagatedBuildInputs = [
    lwt_log
    ocsipersist
    pgocaml
  ];

  meta = ocsipersist.meta // {
    description = "Persistent key/value storage for OCaml using PostgreSQL";
  };
}
