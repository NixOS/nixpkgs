{ lib, buildPythonPackage, fetchPypi, isPyPy, unixODBC }:

buildPythonPackage rec {
  pname = "pyodbc";
  version = "4.0.32";
  disabled = isPyPy; # use pypypdbc instead

  src = fetchPypi {
    inherit pname version;
    sha256 = "9be5f0c3590655e1968488410fe3528bb8023d527e7ccec1f663d64245071a6b";
  };

  buildInputs = [ unixODBC ];

  doCheck = false; # tests require a database server

  pythonImportsCheck = [ "pyodbc" ];

  meta = with lib; {
    description = "Python ODBC module to connect to almost any database";
    homepage = "https://github.com/mkleehammer/pyodbc";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
