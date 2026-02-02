{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytest,
  pytestCheckHook,
  six,
}:

buildPythonPackage rec {
  pname = "pytest-assume";
  version = "2.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astraw38";
    repo = "pytest-assume";
    tag = "v${version}";
    sha256 = "sha256-QIwETun/n8SnBzK/axWiVTcuWiJ0ph3+2pQYVRMmVWI=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  dependencies = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_assume" ];

  meta = {
    description = "Pytest plugin that allows multiple failures per test";
    homepage = "https://github.com/astraw38/pytest-assume";
    changelog = "https://github.com/astraw38/pytest-assume/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jfr ];
  };
}
