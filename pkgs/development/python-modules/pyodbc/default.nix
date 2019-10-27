{ stdenv, buildPythonPackage, fetchPypi, isPyPy, unixODBC }:

buildPythonPackage rec {
  pname = "pyodbc";
  version = "4.0.27";
  disabled = isPyPy;  # use pypypdbc instead

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kd2i7hc1330cli72vawzby17c3039cqn1aba4i0zrjnpghjhmib";
  };

  buildInputs = [ unixODBC ];

  doCheck = false; # tests require a database server

  meta = with stdenv.lib; {
    description = "Python ODBC module to connect to almost any database";
    homepage = "https://github.com/mkleehammer/pyodbc";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
