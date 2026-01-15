{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  poetry-core,
  pytest-asyncio,
  pytest-httpx,
  pytestCheckHook,
  yarl,
}:

buildPythonPackage rec {
  pname = "elmax";
  version = "0.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-elmax";
    rev = version;
    hash = "sha256-EcYEpYv+EwwEfW8Sy7aQjFAPpmsA6qVbmlwrPdxdnEw=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    httpx
    yarl
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
  ];

  pythonImportsCheck = [ "elmax" ];

  meta = {
    description = "Python API client for the Elmax Cloud services";
    mainProgram = "poetry-template";
    homepage = "https://github.com/home-assistant-ecosystem/python-elmax";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
