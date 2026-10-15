{
  buildDunePackage,
  ocsipersist-lib,
}:

buildDunePackage {
  pname = "ocsipersist";
  inherit (ocsipersist-lib) src version;

  propagatedBuildInputs = [ ocsipersist-lib ];

  meta = ocsipersist-lib.meta // {
    description = "Persistent key/value storage for OCaml using multiple backends";
  };
}
