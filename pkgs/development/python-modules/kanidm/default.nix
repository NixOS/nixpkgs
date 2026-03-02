{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build
  pdm-backend,

  # propagates
  aiohttp,
  authlib,
  pydantic,
  toml,

  # tests
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "kanidm";
  version = "1.8.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kanidm";
    repo = "kanidm";
    tag = "v${version}";
    hash = "sha256-lJX/eObXi468iFOzeFjAnNkPiQ8VbBnfqD1518LDm2s=";
  };

  sourceRoot = "${src.name}/pykanidm";

  build-system = [ pdm-backend ];

  dependencies = [
    aiohttp
    authlib
    pydantic
    toml
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  disabledTestMarks = [ "network" ];

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
