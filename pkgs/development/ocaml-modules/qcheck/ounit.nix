{
  buildDunePackage,
  qcheck-core,
  ounit2,
}:

buildDunePackage {
  pname = "qcheck-ounit";

  inherit (qcheck-core) version src patches;

  propagatedBuildInputs = [
    qcheck-core
    ounit2
  ];

  meta = qcheck-core.meta // {
    description = "OUnit backend for qcheck";
  };

}
