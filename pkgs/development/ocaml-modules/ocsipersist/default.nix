{ buildDunePackage, ocsipersist-lib
, ocsipersist-pgsql
, ocsipersist-sqlite
}:

buildDunePackage {
  pname = "ocsipersist";
  inherit (ocsipersist-lib) src version useDune2;

  buildInputs = [
    ocsipersist-pgsql
    ocsipersist-sqlite
  ];

  propagatedBuildInputs = [ ocsipersist-lib ];

  meta = ocsipersist-lib.meta // {
    description = "Persistent key/value storage (for Ocsigen) using multiple backends";
  };
}
