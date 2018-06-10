{ stdenv, fetchPypi, buildPythonPackage, lxml, typed-ast, psutil, isPy3k }:

buildPythonPackage rec {
  pname = "mypy";
  version = "0.610";

  # Tests not included in pip package.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fc7h7hf9042nlqczdvj2ngz2hc7rcnd35qz5pb840j38x9n8wpl";
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
