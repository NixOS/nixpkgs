{
  buildDunePackage,
  findlib,
  ocsipersist-pgsql,
  ocsigen_server,
  xml-light,
}:

buildDunePackage {
  pname = "ocsipersist-pgsql-config";
  inherit (ocsipersist-pgsql) version src;

  propagatedBuildInputs = [
    findlib
    ocsipersist-pgsql
    ocsigen_server
    xml-light
  ];

  meta = ocsipersist-pgsql.meta // {
    description = "Ocsigen Server configuration file extension for ocsipersist-pgsql";
  };
}
