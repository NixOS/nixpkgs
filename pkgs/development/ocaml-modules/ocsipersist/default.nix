{ buildDunePackage, ocsipersist-lib
}:

buildDunePackage {
  pname = "ocsipersist";
  inherit (ocsipersist-lib) src version;
  duneVersion = "3";


  propagatedBuildInputs = [ ocsipersist-lib ];

  meta = ocsipersist-lib.meta // {
    description = "Persistent key/value storage (for Ocsigen) using multiple backends";
  };
}
