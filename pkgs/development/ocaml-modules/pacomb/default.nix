{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ppxlib,
  stdlib-shims,
}:

buildDunePackage (finalAttrs: {
  pname = "pacomb";
  version = "1.4.4";
  src = fetchFromGitHub {
    owner = "craff";
    repo = "pacomb";
    tag = finalAttrs.version;
    hash = "sha256-wd/81NXXrKLq+SQI2E1ddcIld5tCCdSA9EYfdv8pkE0=";
  };
  buildInputs = [
    ppxlib
  ];
  propagatedBuildInputs = [
    stdlib-shims
  ];
  minimalOCamlVersion = "5.3";

  meta = {
    description = "Parsing library based on combinators and ppx extension to write languages";
    homepage = "https://github.com/craff/pacomb";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ redianthus ];
  };
})
