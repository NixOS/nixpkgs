{
  lib,
  fetchurl,
  buildDunePackage,
  ptime,
  re,
  uutf,
  alcotest,
  crowbar,
  fmt,
  rresult,
}:

buildDunePackage (finalAttrs: {
  pname = "conan";
  version = "0.0.8";

  src = fetchurl {
    url = "https://github.com/mirage/conan/releases/download/v${finalAttrs.version}/conan-${finalAttrs.version}.tbz";
    hash = "sha256-R4xt2sT7PD9D6ffHG+GqMJ0Y8JtH4Jf8mz5dzQR1N8U=";
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
})
