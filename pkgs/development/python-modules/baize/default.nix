{
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  lib,
  pdm-backend,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  starlette,
}:

buildPythonPackage rec {
  pname = "baize";
  version = "0.23.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abersheeran";
    repo = "baize";
    tag = "v${version}";
    hash = "sha256-TclyTLqJ+r9Spg6VgmsqhhVj/Mp/HqFrkXjZy5f2BR0=";
  };

  build-system = [
    pdm-backend
    setuptools
  ];

  pythonImportsCheck = [ "baize" ];

  nativeCheckInputs = [
    httpx
    pytest-asyncio
    pytestCheckHook
    starlette
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
