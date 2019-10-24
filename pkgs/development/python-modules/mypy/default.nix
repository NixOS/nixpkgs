{ stdenv, fetchPypi, buildPythonPackage, typed-ast, psutil, isPy3k
,mypy_extensions }:

buildPythonPackage rec {
  pname = "mypy";
  version = "0.740";

  # Tests not included in pip package.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "48c8bc99380575deb39f5d3400ebb6a8a1cb5cc669bbba4d3bb30f904e0a0e7d";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ typed-ast psutil mypy_extensions ];

  meta = with stdenv.lib; {
    description = "Optional static typing for Python";
    homepage    = "http://www.mypy-lang.org";
    license     = licenses.mit;
    maintainers = with maintainers; [ martingms lnl7 ];
  };
}
