{ lib
, aiohttp
, aioresponses
, apischema
, buildPythonPackage
, fetchFromGitHub
, freezegun
, gql
, graphql-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, requests
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pydrawise";
  version = "2024.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "dknowles2";
    repo = "pydrawise";
    rev = "refs/tags/${version}";
    hash = "sha256-fMwWGE6WfgENti4H+WSfd8ZSHqxHyBVATUhng/o8qeY=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    aiohttp
    apischema
    gql
    graphql-core
    requests
  ];

  nativeCheckInputs = [
    aioresponses
    freezegun
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pydrawise"
  ];

  meta = with lib; {
    description = "Library for interacting with Hydrawise sprinkler controllers through the GraphQL API";
    homepage = "https://github.com/dknowles2/pydrawise";
    changelog = "https://github.com/dknowles2/pydrawise/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
