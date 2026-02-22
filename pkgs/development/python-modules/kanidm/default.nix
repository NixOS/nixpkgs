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
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kanidm";
    repo = "kanidm";
    rev = "d9a952b8816054b6f10be564dcd43a7202a2ef02";
    hash = "sha256-JTo883Lq4CbzQ9G5y3XDgBC696r+Fyk5I3m9G9uYwVk=";
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
      adamcstephens
      arianvp
      hexa
    ];
  };
}
