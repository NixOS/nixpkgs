{ stdenv, buildPythonPackage, fetchPypi, isPyPy, unixODBC }:

buildPythonPackage rec {
  pname = "pyodbc";
  version = "4.0.25";
  disabled = isPyPy;  # use pypypdbc instead

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bbwrb812w5i0x56jfn0l86mxc2ck904hl8y87mziay96znwia0f";
  };

  buildInputs = [ unixODBC ];

  doCheck = false; # tests require a database server

  meta = with stdenv.lib; {
    description = "Python ODBC module to connect to almost any database";
    homepage = "https://github.com/mkleehammer/pyodbc";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor ];
  };
}
