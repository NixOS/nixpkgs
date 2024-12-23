{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  urllib3,
}:

buildPythonPackage rec {
  pname = "freebox-api";
  version = "1.2.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = "freebox-api";
    tag = "v${version}";
    hash = "sha256-a4d7fjSPBcVlCkY8y7dTLPW949YUg9wD62kQxJRxp0I=";
  };

  build-system = [
    poetry-core
  ];

  pythonRelaxDeps = [ "urllib3" ];

  dependencies = [
    aiohttp
    urllib3
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "freebox_api" ];

  meta = with lib; {
    description = "Python module to interact with the Freebox OS API";
    mainProgram = "freebox_api";
    homepage = "https://github.com/hacf-fr/freebox-api";
    changelog = "https://github.com/hacf-fr/freebox-api/releases/tag/v${version}";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
