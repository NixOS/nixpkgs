{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  pythonAtLeast,
  pythonOlder,
  stdenv,

  # build-system
  setuptools,
  types-psutil,
  types-setuptools,

  # propagates
  basedtyping,
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
  pname = "basedmypy";
  version = "2.10.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "KotlinIsland";
    repo = "basedmypy";
    tag = "v${version}";
    hash = "sha256-/43wVQoW/BbRD8j8Oypq5yz79ZTyAkLD4T8/aUg/QT8=";
  };

  postPatch = ''
    substituteInPlace \
      pyproject.toml \
      --replace-warn 'types-setuptools==' 'types-setuptools>='
  '';

  build-system = [
    basedtyping
    mypy-extensions
    types-psutil
    types-setuptools
    typing-extensions
  ]
  ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  dependencies = [
    basedtyping
    mypy-extensions
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

  disabledTests = lib.optionals (pythonAtLeast "3.12") [
    # cannot find distutils, and distutils cannot find types
    # https://github.com/NixOS/nixpkgs/pull/364818#discussion_r1895715378
    "test_c_unit_test"
  ];

  disabledTestPaths = [
    # fails to find typing_extensions
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Based Python static type checker with baseline, sane default settings and based typing features";
    homepage = "https://kotlinisland.github.io/basedmypy/";
    changelog = "https://github.com/KotlinIsland/basedmypy/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "mypy";
    maintainers = with lib.maintainers; [ perchun ];
  };
}
