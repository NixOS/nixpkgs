{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools-scm,
  flake8,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-flake8";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "coherent-oss";
    repo = "pytest-flake8";
    tag = "v${version}";
    hash = "sha256-uc5DOqqdoLfhzI2ogDOqhbJOHzdu+uqSOojIH+S1LZI=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ flake8 ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/coherent-oss/pytest-flake8/blob/${src.rev}/NEWS.rst";
    description = "py.test plugin for efficiently checking PEP8 compliance";
    homepage = "https://github.com/coherent-oss/pytest-flake8";
    maintainers = with lib.maintainers; [ jluttine ];
    license = lib.licenses.bsd2;
  };
}
