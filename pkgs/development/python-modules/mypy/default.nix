{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  pythonOlder,

  # build-system
  setuptools,
  types-psutil,
  types-setuptools,
  wheel,

  # propagates
  mypy-extensions,
  tomli,
  typing-extensions,

  # optionals
  lxml,
  psutil,

  # tests
  attrs,
  filelock,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mypy";
  version = "1.10.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python";
    repo = "mypy";
    rev = "refs/tags/v${version}";
    hash = "sha256-NCnc4C/YFKHN/kT7RTFCYs/yC00Kt1E7mWCoQuUjxG8=";
  };

  build-system = [
    mypy-extensions
    setuptools
    types-psutil
    types-setuptools
    typing-extensions
    wheel
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  dependencies = [
    mypy-extensions
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  optional-dependencies = {
    dmypy = [ psutil ];
    reports = [ lxml ];
  };

  # Compile mypy with mypyc, which makes mypy about 4 times faster. The compiled
  # version is also the default in the wheels on Pypi that include binaries.
  # is64bit: unfortunately the build would exhaust all possible memory on i686-linux.
  env.MYPY_USE_MYPYC = stdenv.buildPlatform.is64bit;

  # when testing reduce optimisation level to reduce build time by 20%
  env.MYPYC_OPT_LEVEL = 1;

  pythonImportsCheck =
    [
      "mypy"
      "mypy.api"
      "mypy.fastparse"
      "mypy.types"
      "mypyc"
      "mypyc.analysis"
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isi686) [
      # ImportError: cannot import name 'map_instance_to_supertype' from partially initialized module 'mypy.maptype' (most likely due to a circular import)
      "mypy.report"
    ];

  nativeCheckInputs = [
    attrs
    filelock
    pytest-xdist
    pytestCheckHook
    setuptools
    tomli
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  disabledTests =
    [
      # fails with typing-extensions>=4.10
      # https://github.com/python/mypy/issues/17005
      "test_runtime_typing_objects"
    ]
    ++ lib.optionals (pythonAtLeast "3.12") [
      # requires distutils
      "test_c_unit_test"
    ];

  disabledTestPaths =
    [
      # fails to find tyoing_extensions
      "mypy/test/testcmdline.py"
      "mypy/test/testdaemon.py"
      # fails to find setuptools
      "mypyc/test/test_commandline.py"
      # fails to find hatchling
      "mypy/test/testpep561.py"
    ]
    ++ lib.optionals stdenv.hostPlatform.isi686 [
      # https://github.com/python/mypy/issues/15221
      "mypyc/test/test_run.py"
    ];

  meta = with lib; {
    description = "Optional static typing for Python";
    homepage = "https://www.mypy-lang.org";
    license = licenses.mit;
    mainProgram = "mypy";
    maintainers = with maintainers; [ lnl7 ];
  };
}
