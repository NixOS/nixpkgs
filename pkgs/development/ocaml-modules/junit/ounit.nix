{ buildDunePackage, junit, ounit }:

buildDunePackage ({
  pname = "junit_ounit";

  inherit (junit) src version meta useDune2;

  propagatedBuildInputs = [
    junit
    ounit
  ];

  doCheck = true;
})
