{
  buildDunePackage,
  findlib,
  ocsipersist-sqlite,
  ocsigen_server,
  xml-light,
}:

buildDunePackage {
  pname = "ocsipersist-sqlite-config";
  inherit (ocsipersist-sqlite) version src;

  propagatedBuildInputs = [
    findlib
    ocsipersist-sqlite
    ocsigen_server
    xml-light
  ];

  meta = ocsipersist-sqlite.meta // {
    description = "Ocsigen Server configuration file extension for ocsipersist-sqlite";
  };
}
