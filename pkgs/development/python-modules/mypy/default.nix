{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  pythonAtLeast,
  isPyPy,

  # build-system
  pathspec,
  setuptools,
  types-psutil,
  types-setuptools,

  # propagates
  librt,
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
  version = "1.20.1";
  pyproject = true;

  # relies on several CPython internals
  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "python";
    repo = "mypy";
    tag = "v${version}";
    hash = "sha256-MQZZyGu6xFh3wO+0lWED+mingjK92v/onljtp9gylmM=";
  };

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
    librt
    mypy-extensions
    pathspec
    typing-extensions
  ];

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
  ++ lib.concatAttrValues optional-dependencies;

  disabledTests = [
    # A change to the base64 decoder in CPython 3.13.13 and 3.14.4 causes this
    # test to fail. At the time of writing, upstream skips the test.
    # Upstream issue: https://github.com/python/mypy/issues/21120
    # CPython issue: https://github.com/python/cpython/issues/145264
    "testAllBase64Features_librt_experimental"
    # https://github.com/python/mypy/issues/21120
    "testAllBase64Features_librt"
    # fails to import librt
    "test_diff_cache_produces_valid_json"
  ]
  ++ lib.optionals (pythonAtLeast "3.12") [
    # requires distutils
    "test_c_unit_test"
  ];

  disabledTestPaths = [
    # circular dependency on distutils
    "mypyc/test/test_external.py"
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
