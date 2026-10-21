{
  buildDunePackage,
  conan,
  cachet,
  alcotest,
  crowbar,
  fmt,
  rresult,
}:

buildDunePackage {
  pname = "conan-unix";
  inherit (conan) version src meta;

  propagatedBuildInputs = [
    cachet
    conan
  ];

  doCheck = true;

  checkInputs = [
    alcotest
    crowbar
    fmt
    rresult
  ];
}
