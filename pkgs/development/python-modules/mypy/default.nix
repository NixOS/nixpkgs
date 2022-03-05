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
  version = "0.931";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "python";
    repo = "mypy";
    rev = "v${version}";
    sha256 = "1v83flrdxh8grcp40qw04q4hzjflih9xwib64078vsxv2w36f817";
  };

  patches = [
    # FIXME: Remove patch after upstream has decided the proper solution.
    #        https://github.com/python/mypy/pull/11143
    (fetchpatch {
      url = "https://github.com/python/mypy/commit/f1755259d54330cd087cae763cd5bbbff26e3e8a.patch";
      sha256 = "sha256-5gPahX2X6+/qUaqDQIGJGvh9lQ2EDtks2cpQutgbOHk=";
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
