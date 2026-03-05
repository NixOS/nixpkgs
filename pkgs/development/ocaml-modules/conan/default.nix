{
  lib,
  fetchurl,
  buildDunePackage,
  version ? "0.0.7",
  ptime,
  re,
  uutf,
  alcotest,
  crowbar,
  fmt,
  rresult,
}:

buildDunePackage {
  pname = "conan";
  inherit version;

  src = fetchurl {
    url = "https://github.com/mirage/conan/releases/download/v${version}/conan-${version}.tbz";
    hash = "sha256-4ZbyGLnPRImRQ8vO71i+jlEWYB/FJCSelY7uBuH4dBU=";
  };

  propagatedBuildInputs = [
    ptime
    re
    uutf
  ];

  doCheck = true;

  checkInputs = [
    alcotest
    crowbar
    fmt
    rresult
  ];

  minimalOCamlVersion = "4.12";

  meta = {
    description = "Identify type of your file (such as the MIME type)";
    homepage = "https://github.com/mirage/conan";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
