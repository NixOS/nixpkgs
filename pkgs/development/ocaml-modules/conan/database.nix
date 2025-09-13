{
  buildDunePackage,
  conan,
  alcotest,
  crowbar,
  fmt,
  rresult,
}:

buildDunePackage {
  pname = "conan-database";
  inherit (conan) version src;

  propagatedBuildInputs = [ conan ];

  doCheck = true;

  checkInputs = [
    alcotest
    crowbar
    fmt
    rresult
  ];

  meta = conan.meta // {
    description = "Database of decision trees to recognize MIME type";
  };
}
