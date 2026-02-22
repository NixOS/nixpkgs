{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  aiohttp,
  aiohttp-retry,
  pyjwt,
}:

buildPythonPackage rec {
  pname = "apple-weatherkit";
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tjhorner";
    repo = "python-weatherkit";
    tag = "v${version}";
    hash = "sha256-JvN8GmlTxz9VGttIFVG6q//c+BhP2pt1tBOhnJhNwJg=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    aiohttp-retry
    pyjwt
  ]
  ++ pyjwt.optional-dependencies.crypto;

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "apple_weatherkit" ];

  meta = {
    description = "Python library for Apple WeatherKit";
    homepage = "https://github.com/tjhorner/python-weatherkit";
    changelog = "https://github.com/tjhorner/python-weatherkit/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
