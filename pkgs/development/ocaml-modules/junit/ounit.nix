{
  buildDunePackage,
  junit,
  ounit2,
}:

buildDunePackage ({
  pname = "junit_ounit";

  inherit (junit) src version meta;

  propagatedBuildInputs = [
    junit
    ounit2
  ];

  doCheck = true;
})
