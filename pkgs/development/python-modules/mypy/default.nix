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
, setuptools
, six
, typed-ast
, typing-extensions
, tomli
, types-setuptools
, types-typed-ast
, types-psutil
, virtualenv
}:

buildPythonPackage rec {
  pname = "mypy";
  version = "0.991";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python";
    repo = "mypy";
    rev = "refs/tags/v${version}";
    hash = "sha256-ljnMlQUlz4oiZqlqOlqJOumrP6wKLDGiDtT3Y5OEQog=";
  };

  nativeBuildInputs = [
    setuptools
    types-typed-ast
    types-setuptools
    types-psutil
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
    "mypy.types"
    "mypyc"
    "mypyc.analysis"
  ] ++ lib.optionals (!stdenv.hostPlatform.isi686) [
    # ImportError: cannot import name 'map_instance_to_supertype' from partially initialized module 'mypy.maptype' (most likely due to a circular import)
    "mypy.report"
  ];

  # Compile mypy with mypyc, which makes mypy about 4 times faster. The compiled
  # version is also the default in the wheels on Pypi that include binaries.
  # is64bit: unfortunately the build would exhaust all possible memory on i686-linux.
  MYPY_USE_MYPYC = stdenv.buildPlatform.is64bit;

  # when testing reduce optimisation level to drastically reduce build time
  MYPYC_OPT_LEVEL = 1;

  meta = with lib; {
    description = "Optional static typing for Python";
    homepage = "https://www.mypy-lang.org";
    license = licenses.mit;
    maintainers = with maintainers; [ martingms lnl7 SuperSandro2000 ];
  };
}
