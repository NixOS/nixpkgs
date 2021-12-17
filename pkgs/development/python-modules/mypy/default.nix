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
  version = "unstable-2021-11-14";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "python";
    repo = "mypy";
    rev = "053a1beb94ee4e5b3260725594315d1b6776e42f";
    sha256 = "sha256-q2ntj3y3GgXrw4v+yMvcqWFv4y/6YwunIj3bNzU9CH0=";
  };

  patches = [
    # FIXME: Remove patch after upstream has decided the proper solution.
    #        https://github.com/python/mypy/pull/11143
    (fetchpatch {
      url = "https://github.com/python/mypy/commit/f1755259d54330cd087cae763cd5bbbff26e3e8a.patch";
      sha256 = "sha256-5gPahX2X6+/qUaqDQIGJGvh9lQ2EDtks2cpQutgbOHk=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "tomli>=1.1.0,<1.2.0" "tomli"
  '';

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
