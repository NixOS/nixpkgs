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
  klayout,
  loguru,
  numpy,
  pydantic-extra-types,
  pydantic-settings,
  pydantic,
  pygit2,
  rapidfuzz,
  rectangle-packer,
  requests,
  ruamel-yaml-string,
  ruamel-yaml,
  scipy,
  semver,
  toolz,
  typer,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "kfactory";
  version = "1.14.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gdsfactory";
    repo = "kfactory";
    tag = "v${version}";
    hash = "sha256-dwJqKl6o2w8fxcNMQAvt5dI1k89yoy/PiIH9eo3JQbA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aenum
    cachetools
    klayout
    loguru
    numpy
    pydantic
    pydantic-extra-types
    pydantic-settings
    pygit2
    rapidfuzz
    rectangle-packer
    requests
    ruamel-yaml
    ruamel-yaml-string
    scipy
    semver
    toolz
    typer
  ];

  pythonImportsCheck = [ "kfactory" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # https://github.com/gdsfactory/kfactory/issues/511
    "tests/test_pdk.py"
    # NameError
    "tests/test_session.py"
  ];

  meta = {
    description = "KLayout API implementation of gdsfactory";
    homepage = "https://github.com/gdsfactory/kfactory";
    changelog = "https://github.com/gdsfactory/kfactory/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fbeffa ];
  };
}
