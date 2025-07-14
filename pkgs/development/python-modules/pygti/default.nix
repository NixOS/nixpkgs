{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  aiohttp,
  pytz,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "pygti";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vigonotion";
    repo = "pygti";
    tag = version;
    hash = "sha256-2T4Yw4XEOkv+IWyB4Xa2dPu929VH0tLeUjQ5S8EVXz0=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    aiohttp
    pytz
    voluptuous
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [
    "pygti.auth"
    "pygti.exceptions"
    "pygti.gti"
  ];

  meta = {
    changelog = "https://github.com/vigonotion/pygti/releases/tag/${src.tag}";
    description = "Access public transport information in Hamburg, Germany";
    homepage = "https://github.com/vigonotion/pygti";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
