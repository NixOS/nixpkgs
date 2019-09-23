{ stdenv, fetchPypi, buildPythonPackage, typed-ast, psutil, isPy3k
,mypy_extensions }:

buildPythonPackage rec {
  pname = "mypy";
  version = "0.711";

  # Tests not included in pip package.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s1kwi1dhrv55v0c9w7c1g6mq5d2dpw7x1jj5mcnniw77mclmvdv";
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
