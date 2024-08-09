{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  py,
  pytest,
  pycodestyle,
}:

buildPythonPackage rec {
  pname = "pytest-pycodestyle";
  version = "2.3.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KQEye45r6rkCmKmAMHRIPv5WDhkb74HZ4YEZsUEiKDA=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    pycodestyle
    py
    pytest
  ];

  pythonImportsCheck = [ "pytest_pycodestyle" ];

  meta = {
    description = "Pytest plugin to run pycodestyle";
    homepage = "https://pypi.org/project/pytest-pycodestyle/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ByteSudoer ];
  };
}
