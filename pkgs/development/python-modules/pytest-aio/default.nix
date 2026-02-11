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
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "klen";
    repo = "pytest-aio";
    rev = "43681bcfc6d2ee07bf9397a1b42d1ccfbb891deb";
    hash = "sha256-IBtiy4pyXblIkYQunFO6HpBkCnBcEpTqcFtVELrULkk=";
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
  ]
  # https://github.com/python-trio/trio-asyncio/issues/160
  ++ lib.optionals (pythonOlder "3.14") [
    trio-asyncio
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "pytest_aio" ];

  meta = {
    description = "Pytest plugin for aiohttp support";
    homepage = "https://github.com/klen/pytest-aio";
    changelog = "https://github.com/klen/pytest-aio/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
