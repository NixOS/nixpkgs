{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  ipython,
  ipython-genutils,
  prettytable,
  six,
  sqlalchemy,
  sqlparse,
}:
buildPythonPackage rec {
  pname = "ipython-sql";
  version = "0.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PbPOf5qV369Dh2+oCxa9u5oE3guhIELKsT6fWW/P/b4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    ipython
    ipython-genutils
    prettytable
    six
    sqlalchemy
    sqlparse
  ];

  # pypi tarball has no tests
  doCheck = false;

  pythonImportsCheck = [ "sql" ];

  meta = {
    description = "Introduces a %sql (or %%sql) magic";
    homepage = "https://github.com/catherinedevlin/ipython-sql";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cpcloud ];
  };
}
