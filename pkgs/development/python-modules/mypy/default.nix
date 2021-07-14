{ lib
, stdenv
, fetchPypi
, buildPythonPackage
, typed-ast
, isPy3k
, mypy-extensions
, typing-extensions
, toml
, types-toml
, types-typed-ast
}:
buildPythonPackage rec {
  pname = "mypy";
  version = "0.910";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-cECYMCRzyzGiGPF3Woc7N2swtMGCKUIenp3IkW/RYVA=";
  };

  nativeBuildInputs = [
    types-toml
    types-typed-ast
  ];

  propagatedBuildInputs = [ typed-ast mypy-extensions typing-extensions toml ];

  # Tests not included in pip package.
  doCheck = false;

  pythonImportsCheck = [
    "mypy"
    "mypy.types"
    "mypy.api"
    "mypy.fastparse"
    "mypy.report"
    "mypyc"
    "mypyc.analysis"
  ];

  # Compile mypy with mypyc, which makes mypy about 4 times faster. The compiled
  # version is also the default in the wheels on Pypi that include binaries.
  # is64bit: unfortunately the build would exhaust all possible memory on i686-linux.
  MYPY_USE_MYPYC = stdenv.buildPlatform.is64bit;

  meta = with lib; {
    description = "Optional static typing for Python";
    homepage = "http://www.mypy-lang.org";
    license = licenses.mit;
    maintainers = with maintainers; [ martingms lnl7 ];
  };
}
