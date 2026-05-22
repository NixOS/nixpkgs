{
  buildDunePackage,
  conan,
  lwt,
  bstr,
  alcotest,
  crowbar,
  fmt,
  rresult,
}:

buildDunePackage {
  pname = "conan-lwt";
  inherit (conan) version src meta;

  propagatedBuildInputs = [
    conan
    lwt
    bstr
  ];

  doCheck = true;

  checkInputs = [
    alcotest
    crowbar
    fmt
    rresult
  ];
}
