{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-datadir";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gabrielcnr";
    repo = "pytest-datadir";
    tag = "v${version}";
    hash = "sha256-ttzYFzePPpFY6DfMGLVImZMiehuR9IhmIFxBlgrDDmk=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_datadir" ];

  meta = {
    description = "Pytest plugin for manipulating test data directories and files";
    homepage = "https://github.com/gabrielcnr/pytest-datadir";
    changelog = "https://github.com/gabrielcnr/pytest-datadir/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kira-bruneau ];
  };
}
