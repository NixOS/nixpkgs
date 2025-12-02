{
  lib,
  anyio,
  buildPythonPackage,
  curio-compat,
  fetchFromGitHub,
  hypothesis,
  pytest,
  pytestCheckHook,
  pythonOlder,
  poetry-core,
  trio,
  trio-asyncio,
  uvloop,
}:

buildPythonPackage rec {
  pname = "pytest-aio";
  version = "1.9.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "klen";
    repo = "pytest-aio";
    tag = version;
    hash = "sha256-6RxYn8/HAvXv1AEgSIEOLiaBkGgTcqQhWK+xbtxgj/o=";
  };

  build-system = [ poetry-core ];

  buildInputs = [ pytest ];

  optional-dependencies = {
    curio = [ curio-compat ];
    trio = [ trio ];
    uvloop = [ uvloop ];
  };

  nativeCheckInputs = [
    anyio
    hypothesis
    pytestCheckHook
    trio-asyncio
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "pytest_aio" ];

  meta = with lib; {
    description = "Pytest plugin for aiohttp support";
    homepage = "https://github.com/klen/pytest-aio";
    changelog = "https://github.com/klen/pytest-aio/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
