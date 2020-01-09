{ stdenv, fetchPypi, buildPythonPackage, typed-ast, psutil, isPy3k
, mypy-extensions
, typing-extensions
}:

buildPythonPackage rec {
  pname = "mypy";
  version = "0.761";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gw7h84d21wmi267kmgqs9whz0l7rp62pzja2f31wq7cfj6spfl5";
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
