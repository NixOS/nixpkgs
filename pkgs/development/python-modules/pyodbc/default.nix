{ stdenv, buildPythonPackage, fetchPypi, isPyPy, libiodbc }:

buildPythonPackage rec {
  pname = "pyodbc";
  version = "4.0.19";
  name = "${pname}-${version}";
  disabled = isPyPy;  # use pypypdbc instead

  src = fetchPypi {
    inherit pname version;
    sha256 = "05mkaxbi9n02bpr3l0qnyfb3458f35hk71bq8jmadikp3h8al7dg";
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
