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
  version = "0.9.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "signalkraft";
    repo = "myPyllant";
    tag = "v${version}";
    hash = "sha256-wvqlTlcNy/ue2yfrQyS93vfRSOTsHbvARI+7BKuUuYs=";
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
