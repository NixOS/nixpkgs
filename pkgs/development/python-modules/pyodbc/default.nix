{ stdenv, buildPythonPackage, fetchPypi, isPyPy, libiodbc }:

buildPythonPackage rec {
  pname = "pyodbc";
  version = "4.0.22";
  name = "${pname}-${version}";
  disabled = isPyPy;  # use pypypdbc instead

  src = fetchPypi {
    inherit pname version;
    sha256 = "e2d742b42c8b92b10018c51d673fe72d925ab90d4dbaaccd4f209e10e228ba73";
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
