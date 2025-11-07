{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-datadir";
  version = "1.8.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

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

  meta = with lib; {
    description = "Pytest plugin for manipulating test data directories and files";
    homepage = "https://github.com/gabrielcnr/pytest-datadir";
    changelog = "https://github.com/gabrielcnr/pytest-datadir/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
