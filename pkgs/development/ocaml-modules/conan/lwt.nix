{
  buildDunePackage,
  conan,
  lwt,
  bigstringaf,
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
    bigstringaf
  ];

  doCheck = true;

  checkInputs = [
    alcotest
    crowbar
    fmt
    rresult
  ];
}
