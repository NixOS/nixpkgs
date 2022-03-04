{ buildDunePackage, junit, ounit }:

buildDunePackage ({
  pname = "junit_ounit";

  inherit (junit) src version meta;

  propagatedBuildInputs = [
    junit
    ounit
  ];

  doCheck = true;
})
