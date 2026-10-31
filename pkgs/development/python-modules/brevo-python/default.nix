{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  poetry-core,
  pydantic,
  pydantic-core,
  pytest-asyncio,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "brevo-python";
  version = "5.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "getbrevo";
    repo = "brevo-python";
    tag = "v${version}";
    hash = "sha256-L6zRPoiqSNDli0dfBG/wRscRhTBZYXO8nVxyHzq9v70=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    httpx
    pydantic
    pydantic-core
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  patches = [
    # `conftest.py` tries to run `docker` to run `wiremock`
    ./conftest-dont-docker-compose.patch
  ];

  disabledTestPaths = [
    # tests requiring `wiremock`
    "tests/wire/"
  ];

  pythonImportsCheck = [ "brevo" ];

  meta = {
    description = "Fully-featured Python API client to interact with Brevo";
    homepage = "https://github.com/getbrevo/brevo-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
  };
}
