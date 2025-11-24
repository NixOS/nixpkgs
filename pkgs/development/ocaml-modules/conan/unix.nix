{
  buildDunePackage,
  fetchpatch,
  conan,
  alcotest,
  crowbar,
  fmt,
  rresult,
}:

buildDunePackage {
  pname = "conan-unix";
  inherit (conan) version src meta;

  patches = fetchpatch {
    url = "https://github.com/mirage/conan/commit/16872a71be3ef2870d32df849e7abcbaec4fe95d.patch";
    hash = "sha256-/j9nNGOklzNrdIPW7SMNhKln9EMXiXmvPmNRpXc/l/Y=";
  };

  propagatedBuildInputs = [
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
