{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pycodestyle,
  pytest-isort,
  pytest,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytest-pycodestyle";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "henry0312";
    repo = "pytest-pycodestyle";
    tag = "v${version}";
    hash = "sha256-X/vacxI0RFHIqlZ2omzvvFDePS/SZYSFQHEmfcbvf/4=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  dependencies = [ pycodestyle ];

  nativeCheckInputs = [
    pytest-isort
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pytest_pycodestyle" ];

  meta = {
    description = "Pytest plugin to run pycodestyle";
    homepage = "https://github.com/henry0312/pytest-pycodestyle";
    changelog = "https://github.com/henry0312/pytest-pycodestyle/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
