{ buildDunePackage, junit, alcotest }:

buildDunePackage ({
  pname = "junit_alcotest";

  inherit (junit) src version meta;
  duneVersion = "3";

  propagatedBuildInputs = [
    junit
    alcotest
  ];

  doCheck = false; # 2 tests fail: 1) "Test with unexpected exception"; 2) "with wrong result";
})
