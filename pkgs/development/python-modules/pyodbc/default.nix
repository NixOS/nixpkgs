{ lib, buildPythonPackage, fetchPypi, isPyPy, unixODBC }:

buildPythonPackage rec {
  pname = "pyodbc";
  version = "4.0.34";
  disabled = isPyPy; # use pypypdbc instead

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-fqeGlTK5a41Smx8I6oV2X5TffkpY6Wiy+NRVNGoD5Fw=";
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
