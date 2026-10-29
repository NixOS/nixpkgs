{
  buildPythonPackage,
  fetchFromGitHub,
  lib,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  aiohttp,
  pydantic,

  # tests
  aioresponses,
  country-list,
  freezegun,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  pyyaml,
  requests,
}:

buildPythonPackage rec {
  pname = "mypyllant";
  version = "0.9.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "signalkraft";
    repo = "myPyllant";
    tag = "v${version}";
    hash = "sha256-hsuRoh8meAlPd5+WlYkjbGhNKDLV5XsKn27zQWnrELQ=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    aiohttp
    pydantic
  ];

  nativeCheckInputs = [
    aioresponses
    country-list
    freezegun
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytest-xdist
    pytestCheckHook
    pyyaml
    requests
  ];

  pythonImportsCheck = [
    "myPyllant"
  ];

  meta = {
    description = "Python library to interact with the API behind the myVAILLANT app";
    homepage = "https://github.com/signalkraft/myPyllant";
    changelog = "https://github.com/signalkraft/myPyllant/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ urbas ];
  };
}
