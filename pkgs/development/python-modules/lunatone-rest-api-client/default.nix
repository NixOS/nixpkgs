{
  aiohttp,
  awesomeversion,
  buildPythonPackage,
  fetchFromGitLab,
  hatchling,
  lib,
  pydantic,
  pytest-aioresponses,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "lunatone-rest-api-client";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "lunatone-public";
    repo = "lunatone-rest-api-client";
    tag = "v${version}";
    hash = "sha256-stcpAIxsuJfnI6yJIYFpdCk9XZ9C5crYeK5Q+ixxTGk=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    awesomeversion
    pydantic
  ]
  ++ aiohttp.optional-dependencies.speedups;

  pythonImportsCheck = [ "lunatone_rest_api_client" ];

  nativeCheckInputs = [
    pytest-aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://gitlab.com/lunatone-public/lunatone-rest-api-client/-/blob/${src.tag}/CHANGELOG.md";
    description = "Client library for accessing the Lunatone REST API";
    homepage = "https://gitlab.com/lunatone-public/lunatone-rest-api-client";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
