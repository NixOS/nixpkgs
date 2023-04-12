{ buildDunePackage, junit, ounit }:

buildDunePackage ({
  pname = "junit_ounit";

  inherit (junit) src version meta;
  duneVersion = "3";

  propagatedBuildInputs = [
    junit
    ounit
  ];

  doCheck = true;
})
