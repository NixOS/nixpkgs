{
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  lib,
  pdm-pep517,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  starlette,
}:

buildPythonPackage rec {
  pname = "baize";
  version = "0.22.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abersheeran";
    repo = "baize";
    rev = "refs/tags/v${version}";
    hash = "sha256-vsYt1q8QEDmEXjd8dlzHr85Fz3YAjPowS+oBWYGbG1o=";
  };

  build-system = [
    pdm-pep517
    setuptools
  ];

  pythonImportsCheck = [ "baize" ];

  nativeCheckInputs = [
    httpx
    pytest-asyncio
    pytestCheckHook
    starlette
  ];

  disabledTests = [
    # test relies on last modified date, which is set to 1970-01-01 in the sandbox
    "test_files"
    # starlette.testclient.WebSocketDenialResponse
    "test_request_response"
  ];

  meta = {
    description = "Powerful and exquisite WSGI/ASGI framework/toolkit";
    homepage = "https://github.com/abersheeran/baize";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      dotlambda
      bot-wxt1221
    ];
  };
}
