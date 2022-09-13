{ lib
, stdenv
, fetchFromGitHub
, attrs
, buildPythonPackage
, filelock
, lxml
, mypy-extensions
, psutil
, py
, pytest-forked
, pytest-xdist
, pytestCheckHook
, python
, pythonOlder
, six
, typed-ast
, typing-extensions
, tomli
, types-typed-ast
, virtualenv
}:

buildPythonPackage rec {
  pname = "mypy";
  version = "0.971";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python";
    repo = "mypy";
    rev = "refs/tags/v${version}";
    hash = "sha256-J1lUnJco9rLYgFpJkfujGfVq1CfC4pdvvDzoan3jGkU=";
  };

  nativeBuildInputs = [
    types-typed-ast
  ];

  propagatedBuildInputs = [
    mypy-extensions
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ] ++ lib.optionals (pythonOlder "3.8") [
    typed-ast
  ];

  passthru.optional-dependencies = {
    dmypy = [ psutil ];
    reports = [ lxml ];
  };

  # TODO: enable tests
  doCheck = false;

  pythonImportsCheck = [
    "mypy"
    "mypy.api"
    "mypy.fastparse"
    "mypy.report"
    "mypy.types"
    "mypyc"
    "mypyc.analysis"
  ];

  # Compile mypy with mypyc, which makes mypy about 4 times faster. The compiled
  # version is also the default in the wheels on Pypi that include binaries.
  # is64bit: unfortunately the build would exhaust all possible memory on i686-linux.
  MYPY_USE_MYPYC = stdenv.buildPlatform.is64bit;

  # when testing reduce optimisation level to drastically reduce build time
  MYPYC_OPT_LEVEL = 1;

  meta = with lib; {
    description = "Optional static typing for Python";
    homepage = "http://www.mypy-lang.org";
    license = licenses.mit;
    maintainers = with maintainers; [ martingms lnl7 SuperSandro2000 ];
  };
}
