{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  aenum,
  cachetools,
  gitpython,
  klayout,
  loguru,
  numpy,
  pydantic,
  pydantic-settings,
  rectangle-packer,
  requests,
  ruamel-yaml,
  ruamel-yaml-string,
  scipy,
  tomli,
  toolz,
  typer,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "kfactory";
  version = "1.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gdsfactory";
    repo = "kfactory";
    tag = "v${version}";
    hash = "sha256-C7ner1jkMCHI8/sRiw82l+THhAIWhwJuZ/ctJ9V76Us=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aenum
    cachetools
    gitpython
    klayout
    loguru
    numpy
    pydantic
    pydantic-settings
    rectangle-packer
    requests
    ruamel-yaml
    ruamel-yaml-string
    scipy
    tomli
    toolz
    typer
  ];

  pythonImportsCheck = [ "kfactory" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # https://github.com/gdsfactory/kfactory/issues/511
    "tests/test_pdk.py"
  ];

  meta = {
    description = "KLayout API implementation of gdsfactory";
    homepage = "https://github.com/gdsfactory/kfactory";
    changelog = "https://github.com/gdsfactory/kfactory/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fbeffa ];
  };
}
