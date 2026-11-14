{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  packaging,
  pytestCheckHook,
  requests,
  sh,
}:

buildPythonPackage rec {
  pname = "anybadge";
  version = "1.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jongracecox";
    repo = "anybadge";
    tag = "v${version}";
    hash = "sha256-do6W20O0gy421W72/XN2lQ+CTzM+74vq/ImUEMkP7tM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;
  dependencies = [
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests
    sh
  ];

  disabledTests = [
    # Comparison of CLI output fails
    "test_module_same_output_as_main_cli"
  ];

  disabledTestPaths = [
    # No anybadge-server
    "tests/test_server.py"
  ];

  pythonImportsCheck = [ "anybadge" ];

  meta = {
    description = "Python tool for generating badges for your projects";
    homepage = "https://github.com/jongracecox/anybadge";
    changelog = "https://github.com/jongracecox/anybadge/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
