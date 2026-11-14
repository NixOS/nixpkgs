{
  lib,
  anyio,
  buildPythonPackage,
  curio-compat,
  fetchFromGitHub,
  hatchling,
  hypothesis,
  pytest,
  pytestCheckHook,
  pythonOlder,
  trio-asyncio,
  trio,
  uvloop,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-aio";
  version = "2.1.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "klen";
    repo = "pytest-aio";
    tag = finalAttrs.version;
    hash = "sha256-HvD7bBT8QX9Au5TON4yLit2AOLVSRGqdkkwenyqzhpo=";
  };

  build-system = [ hatchling ];

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
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "pytest_aio" ];

  meta = {
    description = "Pytest plugin for aiohttp support";
    homepage = "https://github.com/klen/pytest-aio";
    changelog = "https://github.com/klen/pytest-aio/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
