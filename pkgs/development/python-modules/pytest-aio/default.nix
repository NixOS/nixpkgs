{
  lib,
  anyio,
  buildPythonPackage,
  curio,
  fetchFromGitHub,
  hypothesis,
  pytest,
  pytestCheckHook,
  pythonOlder,
  poetry-core,
  sniffio,
  trio,
  trio-asyncio,
}:

buildPythonPackage rec {
  pname = "pytest-aio";
  version = "1.8.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "klen";
    repo = "pytest-aio";
    rev = "refs/tags/${version}";
    hash = "sha256-MexIL9yFTzhkJ/61GgYoT54MWV8B0c1/CWkN5FVTvnw=";
  };

  build-system = [ poetry-core ];

  buildInputs = [ pytest ];

  dependencies = [
    anyio
    curio
    hypothesis
    sniffio
    trio
    trio-asyncio
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_aio" ];

  meta = with lib; {
    description = "Pytest plugin for aiohttp support";
    homepage = "https://github.com/klen/pytest-aio";
    changelog = "https://github.com/klen/pytest-aio/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
