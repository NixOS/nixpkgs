{ stdenv, fetchPypi, buildPythonPackage, lxml, typed-ast, psutil, isPy3k }:

buildPythonPackage rec {
  pname = "mypy";
  version = "0.620";

  # Tests not included in pip package.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c770605a579fdd4a014e9f0a34b6c7a36ce69b08100ff728e96e27445cef3b3c";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ lxml typed-ast psutil ];

  meta = with stdenv.lib; {
    description = "Optional static typing for Python";
    homepage    = "http://www.mypy-lang.org";
    license     = licenses.mit;
    maintainers = with maintainers; [ martingms lnl7 ];
  };
}
