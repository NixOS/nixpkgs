{ buildDunePackage, qcheck-ounit }:

buildDunePackage {
  pname = "qcheck";

  inherit (qcheck-ounit) version useDune2 src;

  propagatedBuildInputs = [ qcheck-ounit ];

  meta = qcheck-ounit.meta // {
    description = "Compatibility package for qcheck";
  };

}
