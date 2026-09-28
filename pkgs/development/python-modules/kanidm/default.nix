{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build
  pdm-backend,

  # propagates
  aiohttp,
  aiohttp-retry,
  authlib,
  pydantic,
  python-dateutil,
  toml,
  typing-extensions,

  # tests
  openapi-spec-validator,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "kanidm";
  version = "1.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KlUxW/bJByQnzPdRd9Z5pStH27SpWrCijZc5jlVT5jE=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    aiohttp
    aiohttp-retry
    authlib
    pydantic
    python-dateutil
    toml
    typing-extensions
  ];

  nativeCheckInputs = [
    openapi-spec-validator
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = [
    "test_tokenstuff"
  ];

  disabledTestMarks = [
    "network"
    "openapi"
  ];

  pythonImportsCheck = [ "kanidm" ];

  meta = {
    description = "Kanidm client library";
    homepage = "https://github.com/kanidm/kanidm/tree/master/pykanidm";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      arianvp
      hexa
    ];
  };
}
