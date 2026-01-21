{
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  yarl,
}:

buildPythonPackage rec {
  pname = "iometer";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iometer-gmbh";
    repo = "iometer.py";
    tag = "v${version}";
    hash = "sha256-rr+t8VPiPX9/r7mHo9DjLRjoZ7x/4IadhmDtIi2T0C4=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    yarl
  ];

  pythonImportsCheck = [ "iometer" ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  enabledTestPaths = [
    "tests/test.py"
  ];

  meta = {
    changelog = "https://github.com/iometer-gmbh/iometer.py/releases/tag/${src.tag}";
    description = "Python client for interacting with IOmeter devices over HTTP";
    homepage = "https://github.com/iometer-gmbh/iometer.py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
