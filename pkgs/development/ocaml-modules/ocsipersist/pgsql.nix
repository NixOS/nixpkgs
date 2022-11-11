{ buildDunePackage, ocsipersist-lib
, lwt_log
, ocsigen_server
, pgocaml
, xml-light
}:

buildDunePackage {
  pname = "ocsipersist-pgsql";
  inherit (ocsipersist-lib) version src useDune2;

  propagatedBuildInputs = [
    lwt_log
    ocsigen_server
    ocsipersist-lib
    pgocaml
    xml-light
  ];

  meta = ocsipersist-lib.meta // {
    description = "Persistent key/value storage (for Ocsigen) using PostgreSQL";
  };
}

