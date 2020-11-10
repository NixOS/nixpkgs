{ stdenv, fetchPypi, buildPythonPackage, typed-ast, psutil, isPy3k
, mypy-extensions
, typing-extensions
}:

buildPythonPackage rec {
  pname = "mypy";
  version = "0.790";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-KyG6Ra2e8uLriM5K6t0BEtD1AmQYMkF2/UlKaCS3SXU=";
  };

  propagatedBuildInputs = [ typed-ast psutil mypy-extensions typing-extensions ];

  # Tests not included in pip package.
  doCheck = false;

  pythonImportsCheck = [
    "mypy"
    "mypy.types"
    "mypy.api"
    "mypy.fastparse"
    "mypy.report"
  ];

  meta = with stdenv.lib; {
    description = "Optional static typing for Python";
    homepage    = "http://www.mypy-lang.org";
    license     = licenses.mit;
    maintainers = with maintainers; [ martingms lnl7 ];
  };
}
