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
  version = "1.2.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = "freebox-api";
    tag = "v${version}";
    hash = "sha256-piPC3F63Yqk1rYPYyIoEHSpC8TS4HyIVa8XbQlAgcqA=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [ "urllib3" ];

  dependencies = [
    aiohttp
    urllib3
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "freebox_api" ];

  meta = with lib; {
    description = "Python module to interact with the Freebox OS API";
    homepage = "https://github.com/hacf-fr/freebox-api";
    changelog = "https://github.com/hacf-fr/freebox-api/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "freebox_api";
  };
}
