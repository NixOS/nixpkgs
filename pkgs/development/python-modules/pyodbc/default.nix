{ lib, buildPythonPackage, fetchPypi, isPyPy, unixODBC }:

buildPythonPackage rec {
  pname = "pyodbc";
  version = "4.0.35";
  disabled = isPyPy; # use pypypdbc instead

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-krmvSOi5KEVbyLlL89oFdR+uwJMqEe7iN8GJxtQ55cg=";
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
