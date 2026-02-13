{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  unixODBC,
}:

buildPythonPackage rec {
  pname = "pyodbc";
  version = "5.2.0";
  format = "setuptools";

  disabled = isPyPy; # use pypypdbc instead

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3ovjmAnI3e7uJqS4dqZGNSnNSHpg0Tk+sqk+m81EqPU=";
  };

  nativeBuildInputs = [
    unixODBC # for odbc_config
  ];

  buildInputs = [ unixODBC ];

  # Tests require a database server
  doCheck = false;

  pythonImportsCheck = [ "pyodbc" ];

  meta = {
    description = "Python ODBC module to connect to almost any database";
    homepage = "https://github.com/mkleehammer/pyodbc";
    changelog = "https://github.com/mkleehammer/pyodbc/releases/tag/${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bjornfor ];
  };
}
