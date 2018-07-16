{ stdenv, buildPythonPackage, fetchPypi, isPyPy, libiodbc }:

buildPythonPackage rec {
  pname = "pyodbc";
  version = "4.0.23";
  disabled = isPyPy;  # use pypypdbc instead

  src = fetchPypi {
    inherit pname version;
    sha256 = "bb33d032c1f25781db64e2e4fecf77047fab2ddde42a6cd9496e3c66fb8e9f66";
  };

  buildInputs = [ libiodbc ];

  meta = with stdenv.lib; {
    description = "Python ODBC module to connect to almost any database";
    homepage = "https://github.com/mkleehammer/pyodbc";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor ];
  };
}
