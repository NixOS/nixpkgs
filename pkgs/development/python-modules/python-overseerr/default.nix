{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "python-overseerr";
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-overseerr";
    tag = "v${version}";
    hash = "sha256-91h8ooWzCdH2iO1PoInnlHwR6h1m1hZkdNoJE+D4NWQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "python_overseerr" ];

  meta = {
    description = "Client for Overseerr";
    homepage = "https://github.com/joostlek/python-overseerr";
    changelog = "https://github.com/joostlek/python-overseerr/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
