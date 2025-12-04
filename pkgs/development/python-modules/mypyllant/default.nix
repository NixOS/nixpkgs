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
  pytest-cov,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  pyyaml,
  requests,
}:

buildPythonPackage rec {
  pname = "myPyllant";
  version = "0.9.8";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "signalkraft";
    repo = "myPyllant";
    tag = "v${version}";
    hash = "sha256-eneAFJ4xRL8EKj8Act/YcW7Gx0B85u0g3LTWPlI/B/0=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  nativeCheckInputs = [
    aioresponses
    country-list
    freezegun
    pytest-asyncio
    pytest-cov
    pytest-mock
    pytest-xdist
    pytestCheckHook
    pyyaml
    requests
  ];

  dependencies = [
    aiohttp
    pydantic
  ];

  meta = with lib; {
    description = "A Python library to interact with the API behind the myVAILLANT app";
    homepage = "https://github.com/signalkraft/myPyllant";
    changelog = "https://github.com/signalkraft/myPyllant/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ urbas ];
  };
}
