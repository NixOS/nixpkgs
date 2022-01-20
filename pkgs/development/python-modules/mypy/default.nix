{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, buildPythonPackage
, mypy-extensions
, python
, pythonOlder
, typed-ast
, typing-extensions
, tomli
, types-typed-ast
}:

buildPythonPackage rec {
  pname = "mypy";
  version = "0.941";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "python";
    repo = "mypy";
    rev = "v${version}";
    hash = "sha256-H2SWJA0WWyKV7/5miFawv4JRXu/J7H6Wer1eBL+Tru0=";
  };

  patches = [
    # FIXME: Remove patch after upstream has decided the proper solution.
    #        https://github.com/python/mypy/pull/11143
    (fetchpatch {
      url = "https://github.com/python/mypy/commit/e7869f05751561958b946b562093397027f6d5fa.patch";
      hash = "sha256-waIZ+m3tfvYE4HJ8kL6rN/C4fMjvLEe9UoPbt9mHWIM=";
    })
  ];

  buildInputs = [
    types-typed-ast
  ];

  propagatedBuildInputs = [
    mypy-extensions
    tomli
    typed-ast
    typing-extensions
  ];

  # Tests not included in pip package.
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
