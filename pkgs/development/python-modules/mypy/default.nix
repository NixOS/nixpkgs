{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonOlder

# build-system
, setuptools
, types-psutil
, types-setuptools
, types-typed-ast

# propagates
, mypy-extensions
, tomli
, typing-extensions

# optionals
, lxml
, psutil

# tests
, attrs
, filelock
, pytest-xdist
, pytest-forked
, pytestCheckHook
, py
, six
}:

buildPythonPackage rec {
  pname = "mypy";
<<<<<<< HEAD
  version = "1.4.1";
=======
  version = "1.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python";
    repo = "mypy";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-2PeE/L9J6J0IuUpHZasemM8xxefNJrdzYnutgJjevWQ=";
  };

  patches = [
    (fetchpatch {
      # pytest 7.4 compat
      url = "https://github.com/python/mypy/commit/0a020fa73cf5339a80d81c5b44e17116a5c5307e.patch";
      hash = "sha256-3HQPo+V7T8Gr92clXAt5QJUJPmhjnGjQgFq0qR0whfw=";
=======
    hash = "sha256-vxPEUDC6fkYYiOl5nHf0qwMgPDC+9Vw56eTUQ174raQ=";
  };

  patches = [
    # Fix compatibility with setupptools>=67.4.0
    (fetchpatch {
      # https://github.com/python/mypy/pull/14781
      url = "https://github.com/python/mypy/commit/ab7b69a0532a5fe976c9c2a1b713d82d630692a4.patch";
      hash = "sha256-dtzmoOZP3tOtxrBVhgqpdv+rnrTjTKHxQhBieuJXRtA=";
    })
    (fetchpatch {
      # https://github.com/python/mypy/pull/14787
      url = "https://github.com/python/mypy/commit/243f584d43e6eb316920f3155067ce7c1b65d473.patch";
      hash = "sha256-uuh3S5ZyuJeTXyMvav2uSEao2qq23xMjK8rJjkY8RCY=";
      includes = [ "mypyc/build.py" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    })
  ];

  nativeBuildInputs = [
    mypy-extensions
    setuptools
    types-psutil
    types-setuptools
    types-typed-ast
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  propagatedBuildInputs = [
    mypy-extensions
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  passthru.optional-dependencies = {
    dmypy = [
      psutil
    ];
    reports = [
      lxml
    ];
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
  ] ++ lib.optionals (!stdenv.hostPlatform.isi686) [
    # ImportError: cannot import name 'map_instance_to_supertype' from partially initialized module 'mypy.maptype' (most likely due to a circular import)
    "mypy.report"
  ];

  checkInputs = [
    attrs
    filelock
    pytest-xdist
    pytest-forked
    pytestCheckHook
    py
    setuptools
    six
    tomli
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  disabledTestPaths = [
    # fails to find tyoing_extensions
    "mypy/test/testcmdline.py"
    "mypy/test/testdaemon.py"
    # fails to find setuptools
    "mypyc/test/test_commandline.py"
<<<<<<< HEAD
    # fails to find hatchling
    "mypy/test/testpep561.py"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "Optional static typing for Python";
    homepage = "https://www.mypy-lang.org";
    license = licenses.mit;
<<<<<<< HEAD
    mainProgram = "mypy";
    maintainers = with maintainers; [ martingms lnl7 ];
=======
    maintainers = with maintainers; [ martingms lnl7 SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
