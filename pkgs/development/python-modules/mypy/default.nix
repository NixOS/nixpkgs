{ stdenv, fetchPypi, buildPythonPackage, lxml, typed-ast, psutil, isPy3k }:

buildPythonPackage rec {
  pname = "mypy";
  version = "0.600";

  # Tests not included in pip package.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pd3kkz435wlvi9fwqbi3xag5zs59jcjqi6c9gzdjdn23friq9dw";
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
