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
  version = "1.0.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "erwindouna";
    repo = "pyportainer";
    tag = "v${version}";
    hash = "sha256-Lp2bX5+lsfSPEuc0q+tD8tBrMdKq7GZC+tG0cuieNOQ=";
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
