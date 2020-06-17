{ stdenv, fetchPypi, buildPythonPackage, typed-ast, psutil, isPy3k
, mypy-extensions
, typing-extensions
}:

buildPythonPackage rec {
  pname = "mypy";
  version = "0.780";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "138pbm4pvqsx88x70vdsxas9n17qapkhagi7y8js16i8k9hkpwaf";
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
