{ stdenv, buildPythonPackage, fetchPypi, isPyPy, libiodbc }:

buildPythonPackage rec {
  pname = "pyodbc";
  version = "4.0.21";
  name = "${pname}-${version}";
  disabled = isPyPy;  # use pypypdbc instead

  src = fetchPypi {
    inherit pname version;
    sha256 = "9655f84ca9e5cb2dfffff705601017420c840d55271ba62dd44f05383eff0329";
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
