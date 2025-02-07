{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  httpx,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  respx,
}:

buildPythonPackage rec {
  pname = "pywaze";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "eifinger";
    repo = "pywaze";
    tag = "v${version}";
    hash = "sha256-XE+VdxUjq8KBSIU6rUlBweKEkZD3gqJuy9J4u9JVy7Q=";
  };

  build-system = [ hatchling ];

  dependencies = [ httpx ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [ "pywaze" ];

  meta = with lib; {
    description = "Module for calculating WAZE routes and travel times";
    homepage = "https://github.com/eifinger/pywaze";
    changelog = "https://github.com/eifinger/pywaze/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
