{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cerberus";
  version = "1.3.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyeve";
    repo = "cerberus";
    tag = version;
    hash = "sha256-C7YZjqQtdkakqHXBU3cFUl/gCFvCl3saP14eqt2fdAM=";
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
