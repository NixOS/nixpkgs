{ buildDunePackage, qcheck-ounit }:

buildDunePackage {
  pname = "qcheck";

  inherit (qcheck-ounit) version src patches;

  propagatedBuildInputs = [ qcheck-ounit ];

  meta = qcheck-ounit.meta // {
    description = "Compatibility package for qcheck";
  };

}
