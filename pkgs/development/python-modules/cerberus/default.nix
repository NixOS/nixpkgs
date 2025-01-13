{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cerberus";
  version = "1.3.6";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pyeve";
    repo = "cerberus";
    tag = version;
    hash = "sha256-puQcU8USYtylW5XN0VQzG/dizQR24s7+YgrOxIwaDKQ=";
  };

  build-system = [
    poetry-core
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cerberus" ];

  disabledTestPaths = [
    # We don't care about benchmarks
    "cerberus/benchmarks/"
  ];

  meta = with lib; {
    description = "Schema and data validation tool for Python dictionaries";
    homepage = "http://python-cerberus.org/";
    changelog = "https://github.com/pyeve/cerberus/blob/${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
