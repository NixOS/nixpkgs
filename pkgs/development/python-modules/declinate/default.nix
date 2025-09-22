{
  lib,
  buildPythonPackage,
  fetchFromGitLab,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  typing-extensions,

  # nativeCheckInputs
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "declinate";
  version = "0.0.6";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "ternaris";
    repo = "declinate";
    tag = "v${version}";
    hash = "sha256-JEO/GtbG/yQuj8vJJaWex9mGy6qpWOPHGlKrdG9vt28=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "declinate"
  ];

  meta = {
    description = "Command line interface generator";
    homepage = "https://gitlab.com/ternaris/declinate";
    changelog = "https://gitlab.com/ternaris/declinate/-/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
