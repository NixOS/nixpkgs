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
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kanidm";
    repo = "kanidm";
    rev = "1774f9428ccdc357d514652acbcae49f6b16687a";
    hash = "sha256-SE3b9Ug0EZFygGf9lsmVsQzmop9qOMiCUsbO//1QWF8=";
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
