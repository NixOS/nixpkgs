{
  buildDunePackage,
  ocsipersist-lib,
  ocsipersist,
  ocsipersist-sqlite,
  findlib,
}:

buildDunePackage {
  pname = "ocsipersist-sqlite-config";
  inherit (ocsipersist-lib) version src;
  duneVersion = "3";

  propagatedBuildInputs = [
    ocsipersist-lib
    ocsipersist
    ocsipersist-sqlite
    findlib
  ];

  meta = ocsipersist-lib.meta // {
    description = "Ocsigen Server configuration file extension for ocsipersist-sqlite";
  };

}
