{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  poetry-core,
  pytest-asyncio,
  pytest-httpx,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "glances-api";
  version = "0.9.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-glances-api";
    tag = version;
    hash = "sha256-VLsNMFFt+kMxNw/81OMX4Fg/xCbQloCURmV0OxvClq8=";
  };

  build-system = [ poetry-core ];

  dependencies = [ httpx ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
  ];

  pythonImportsCheck = [ "glances_api" ];

  meta = with lib; {
    description = "Python API for interacting with Glances";
    homepage = "https://github.com/home-assistant-ecosystem/python-glances-api";
    changelog = "https://github.com/home-assistant-ecosystem/python-glances-api/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
