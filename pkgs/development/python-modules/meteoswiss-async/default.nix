{
  lib,
  aiohttp,
  asyncstdlib,
  buildPythonPackage,
  dataclasses-json,
  fetchFromGitHub,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "meteoswiss-async";
  version = "0.1.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "albertomontesg";
    repo = "meteoswiss-async";
    rev = "refs/tags/${version}";
    hash = "sha256-xFvfyLZvBfnbzShKN+94piNUVjV1cfi4jWpc/Xw6XG4=";
  };

  pythonRelaxDeps = [
    "aiohttp"
    "asyncstdlib"
  ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    asyncstdlib
    dataclasses-json
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "meteoswiss_async" ];

  meta = {
    description = "Asynchronous client library for MeteoSwiss API";
    homepage = "https://github.com/albertomontesg/meteoswiss-async";
    changelog = "https://github.com/albertomontesg/meteoswiss-async/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
