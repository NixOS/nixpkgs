{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  pythonOlder,
  unixODBC,
}:

buildPythonPackage rec {
  pname = "pyodbc";
  version = "5.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7" || isPyPy; # use pypypdbc instead

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OX/u5EVhplgL4IztvphkNoWVY/S7N49IIkZVyOmH6mA=";
  };

  nativeBuildInputs = [
    unixODBC # for odbc_config
  ];

  buildInputs = [ unixODBC ];

  # Tests require a database server
  doCheck = false;

  pythonImportsCheck = [ "pyodbc" ];

  meta = with lib; {
    description = "Python ODBC module to connect to almost any database";
    homepage = "https://github.com/mkleehammer/pyodbc";
    changelog = "https://github.com/mkleehammer/pyodbc/releases/tag/${version}";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
