{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytest,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytest-archon";
  version = "0.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jwbargsten";
    repo = "pytest-archon";
    tag = "v${version}";
    hash = "sha256-0YBujBUBpW/FSIlJDRjL5mvYZfirHW07bRyygyoapw8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [
    pytest
  ];

  pythonImportsCheck = [ "pytest_archon" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Tool that helps you structure (large) Python projects";
    homepage = "https://github.com/jwbargsten/pytest-archon";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
