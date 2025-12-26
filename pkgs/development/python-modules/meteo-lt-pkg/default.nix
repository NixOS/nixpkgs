{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "meteo-lt-pkg";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Brunas";
    repo = "meteo_lt-pkg";
    tag = "v${version}";
    hash = "sha256-OjIBgIOSJ65ryIF4D/UUUa1Oq0sPkKnaQEJeviimqhE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
  ];

  pythonImportsCheck = [ "meteo_lt" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # tests contact api.meteo.lt
    "test_get_forecast"
    "test_get_nearest_place"
  ];

  meta = {
    changelog = "https://github.com/Brunas/meteo_lt-pkg/blob/${src.tag}/CHANGELOG.md";
    description = "Meteo.Lt weather forecast package";
    homepage = "https://github.com/Brunas/meteo_lt-pkg";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
