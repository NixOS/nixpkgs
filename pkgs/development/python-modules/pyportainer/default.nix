{
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  mashumaro,
  orjson,
  poetry-core,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "pyportainer";
  version = "1.0.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "erwindouna";
    repo = "pyportainer";
    tag = "v${version}";
    hash = "sha256-5ARTHT5NmRBMOMVRPWAICdScAGUbkebtLyJqUW195Mw=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  pythonImportsCheck = [ "pyportainer" ];

  nativeCheckInputs = [
    aresponses
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  meta = {
    changelog = "https://github.com/erwindouna/pyportainer/releases/tag/${src.tag}";
    description = "Asynchronous Python client for the Portainer API";
    homepage = "https://github.com/erwindouna/pyportainer";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
