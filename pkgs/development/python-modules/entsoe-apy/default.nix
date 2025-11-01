{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  httpx,
  loguru,
  xsdata-pydantic,
}:

buildPythonPackage rec {
  pname = "entsoe-apy";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "berrij";
    repo = "entsoe-apy";
    tag = "v${version}";
    hash = "sha256-ScVXh52lqldcrbi5x4ZlV7JfR1o8RQ0wKF9VIAuTuqQ=";
  };

  pyproject = true;
  build-system = [ setuptools ];

  dependencies = [
    httpx
    loguru
    xsdata-pydantic
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
