{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  httpx,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  respx,
}:

buildPythonPackage rec {
  pname = "pywaze";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eifinger";
    repo = "pywaze";
    tag = "v${version}";
    hash = "sha256-INjVspha4AbxKPMQtL/4BUavFisrQXUGofZ3nuz39UU=";
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

  meta = {
    description = "Module for calculating WAZE routes and travel times";
    homepage = "https://github.com/eifinger/pywaze";
    changelog = "https://github.com/eifinger/pywaze/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
