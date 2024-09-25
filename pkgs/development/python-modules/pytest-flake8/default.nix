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
  version = "1.2.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "coherent-oss";
    repo = "pytest-flake8";
    rev = "refs/tags/v${version}";
    hash = "sha256-FsJysBj5S5HHGay+YZKMgb9RdUN637J+FfNl+m9l6ik=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ flake8 ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    # https://github.com/coherent-oss/pytest-flake8/issues/3
    broken = lib.versionAtLeast flake8.version "6";
    changelog = "https://github.com/coherent-oss/pytest-flake8/blob/${src.rev}/NEWS.rst";
    description = "py.test plugin for efficiently checking PEP8 compliance";
    homepage = "https://github.com/coherent-oss/pytest-flake8";
    maintainers = with lib.maintainers; [ jluttine ];
    license = lib.licenses.bsd2;
  };
}
