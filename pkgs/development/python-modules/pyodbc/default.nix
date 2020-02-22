{ stdenv, buildPythonPackage, fetchPypi, isPyPy, unixODBC }:

buildPythonPackage rec {
  pname = "pyodbc";
  version = "4.0.30";
  disabled = isPyPy;  # use pypypdbc instead

  src = fetchPypi {
    inherit pname version;
    sha256 = "0skjpraar6hcwsy82612bpj8nw016ncyvvq88j5syrikxgp5saw5";
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
