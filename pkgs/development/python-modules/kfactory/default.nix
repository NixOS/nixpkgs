{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  klayout,
  aenum,
  cachetools,
  gitpython,
  loguru,
  pydantic,
  pydantic-settings,
  rectangle-packer,
  requests,
  ruamel-yaml-string,
  scipy,
  tomli,
  toolz,
  typer,
  numpy,
  ruamel-yaml,
}:

buildPythonPackage rec {
  pname = "kfactory";
  version = "0.21.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gdsfactory";
    repo = "kfactory";
    rev = "v${version}";
    sha256 = "sha256-VLhAJ5rOBKEO1FDCnlaseA+SmrMSoyS+BaEzjdHm59Y=";
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

  # https://github.com/gdsfactory/kfactory/issues/511
  disabledTestPaths = [
    "tests/test_pdk.py"
  ];

  meta = with lib; {
    description = "KLayout API implementation of gdsfactory";
    homepage = "https://github.com/gdsfactory/kfactory";
    license = licenses.mit;
    maintainers = with maintainers; [ fbeffa ];
  };
}
