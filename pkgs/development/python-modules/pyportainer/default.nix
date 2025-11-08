{
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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
  version = "1.0.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "erwindouna";
    repo = "pyportainer";
    tag = "v${version}";
    hash = "sha256-goTYZhv/+4o2/SMOqANMnR3u4YxwDJVcvT0pz8MT7M8=";
  };

  patches = [
    (fetchpatch {
      name = "remove-mkdocs-from-dependencies.patch";
      url = "https://github.com/erwindouna/pyportainer/commit/8ed65c3870ff368465267e9bf2cda441b7b28994.patch";
      hash = "sha256-3FE8NngAajIt8lDjG//sDPULq8mZ0f53iVemJ2xJ4MQ=";
    })
  ];

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
