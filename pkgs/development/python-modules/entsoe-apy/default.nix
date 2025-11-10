{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  isodate,
  httpx,
  loguru,
  xsdata-pydantic,
}:

buildPythonPackage rec {
  pname = "entsoe-apy";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "berrij";
    repo = "entsoe-apy";
    tag = "v${version}";
    hash = "sha256-aOZsD8Cio7TjYHnUlgfgVWLB2+AnDw1J2fTcD8PFioE=";
  };

  pyproject = true;
  build-system = [ setuptools ];

  dependencies = [
    httpx
    loguru
    xsdata-pydantic
    isodate
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "entsoe"
  ];

  meta = {
    description = "Python Package to Query the ENTSO-E API";
    homepage = "https://github.com/berrij/entsoe-apy";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ berrij ];
    platforms = lib.platforms.all;
  };
}
