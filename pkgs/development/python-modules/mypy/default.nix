{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  gitUpdater,
  pythonAtLeast,
  pythonOlder,
  isPyPy,

  # build-system
  pathspec,
  setuptools,
  types-psutil,
  types-setuptools,

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
  nixosTests,
}:

buildPythonPackage rec {
  pname = "mypy";
  version = "1.17.1";
  pyproject = true;

  # relies on several CPython internals
  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "python";
    repo = "mypy";
    tag = "v${version}";
    hash = "sha256-FfONUCCMU1bJXHx3GHH46Tu+wYU5FLPOqeCSCi1bRSs=";
  };

  patches = [
    # Fix the build on Darwin with a case‐sensitive store.
    # Remove on next release.
    (fetchpatch {
      url = "https://github.com/python/mypy/commit/7534898319cb7f16738c11e4bc1bdcef0eb13c38.patch";
      hash = "sha256-5jD0JBRnirmoMlUz9+n8G4AqHqCi8BaUX5rEl9NnLts=";
    })
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  build-system = [
    mypy-extensions
    pathspec
    setuptools
    types-psutil
    types-setuptools
    typing-extensions
  ];

  dependencies = [
    mypy-extensions
    pathspec
    typing-extensions
  ]
  ++ lib.optionals (pythonOlder "3.11") [ tomli ];

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

  pythonImportsCheck = [
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
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  disabledTests = [
    # fails with typing-extensions>=4.10
    # https://github.com/python/mypy/issues/17005
    "test_runtime_typing_objects"
  ]
  ++ lib.optionals (pythonAtLeast "3.12") [
    # requires distutils
    "test_c_unit_test"
  ];

  disabledTestPaths = [
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

  passthru.tests = {
    # Failing typing checks on the test-driver result in channel blockers.
    inherit (nixosTests) nixos-test-driver;
  };

  meta = {
    description = "Optional static typing for Python";
    homepage = "https://www.mypy-lang.org";
    changelog = "https://github.com/python/mypy/blob/${src.rev}/CHANGELOG.md";
    downloadPage = "https://github.com/python/mypy";
    license = lib.licenses.mit;
    mainProgram = "mypy";
    maintainers = with lib.maintainers; [ lnl7 ];
  };
}
