{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  fsspec,
  pyyaml,

  # tests
  aiohttp,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyyaml-include";
  version = "2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tanbro";
    repo = "pyyaml-include";
    tag = "v${version}";
    hash = "sha256-nswSYRTZ6LTLSGh78DnrXl3q06Ap1J1IMKOESv1lJoY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    fsspec
    pyyaml
  ];

  nativeCheckInputs = [
    aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "yaml_include" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Extending PyYAML with a custom constructor for including YAML files within YAML files";
    homepage = "https://github.com/tanbro/pyyaml-include";
    changelog = "https://github.com/tanbro/pyyaml-include/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}
