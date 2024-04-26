{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  python-dotenv,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "bring-api";
  version = "0.7.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "miaucl";
    repo = "bring-api";
    rev = "refs/tags/${version}";
    hash = "sha256-ca6VNC1AG+BAzEhH+N3cwXL9pIBwAX6qLWMpgkEjn98=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
    python-dotenv
  ];

  pythonImportsCheck = [ "bring_api" ];

  meta = with lib; {
    description = "Module to access the Bring! shopping lists API";
    homepage = "https://github.com/miaucl/bring-api";
    changelog = "https://github.com/miaucl/bring-api/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
