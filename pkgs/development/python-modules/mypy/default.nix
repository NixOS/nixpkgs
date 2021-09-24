{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, buildPythonPackage
, mypy-extensions
, psutil
, python
, pythonOlder
, typed-ast
, typing-extensions
, tomli
, types-toml
, types-typed-ast
}:

buildPythonPackage rec {
  pname = "mypy";
  version = "unstable-2021-09-17";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "python";
    repo = "mypy";
    rev = "c6e8a0b74c32b99a863153dae55c3ba403a148b5";
    sha256 = "sha256-/hlGkz3o7S8fBrvl0sl4J3LBpbVs1QhiRj9irKgajOs=";
  };

  patches = [
    # FIXME: Remove patch after upstream has decided the proper solution.
    #        https://github.com/python/mypy/pull/11143
    (fetchpatch {
      url = "https://github.com/python/mypy/commit/f1755259d54330cd087cae763cd5bbbff26e3e8a.patch";
      sha256 = "sha256-5gPahX2X6+/qUaqDQIGJGvh9lQ2EDtks2cpQutgbOHk=";
    })
  ];

  nativeBuildInputs = [
    types-toml
    types-typed-ast
  ];

  propagatedBuildInputs = [
    mypy-extensions
    psutil
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

  meta = with lib; {
    description = "Optional static typing for Python";
    homepage = "http://www.mypy-lang.org";
    license = licenses.mit;
    maintainers = with maintainers; [ martingms lnl7 ];
  };
}
