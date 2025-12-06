{
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  lib,
  pytest_9,
  pythonOlder,
  writeText,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  attrs,
  exceptiongroup,
  iniconfig,
  packaging,
  pluggy,
  tomli,

  # optional-dependencies
  argcomplete,
  hypothesis,
  mock,
  pygments,
  requests,
  xmlschema,
}:

buildPythonPackage rec {
  pname = "pytest";
  version = "9.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest";
    tag = version;
    hash = "sha256-kZSEv/6/ByMoydp/RuBdKU6ITJlDWA2lt4myPbojAMU=";
  };

  outputs = [
    "out"
    "testout"
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    iniconfig
    packaging
    pluggy
    pygments
  ]
  ++ lib.optionals (pythonOlder "3.11") [
    exceptiongroup
    tomli
  ];

  optional-dependencies = {
    testing = [
      argcomplete
      attrs
      hypothesis
      mock
      requests
      setuptools
      xmlschema
    ];
  };

  postInstall = ''
    mkdir $testout
    cp -R testing $testout/testing
  '';

  doCheck = false;
  passthru.tests.pytest = callPackage ./tests.nix {
    pytest = pytest_9;
  };

  # Remove .pytest_cache when using py.test in a Nix build
  setupHook = writeText "pytest-hook" ''
    pytestcachePhase() {
        find $out -name .pytest_cache -type d -exec rm -rf {} +
    }
    appendToVar preDistPhases pytestcachePhase

    # pytest generates it's own bytecode files to improve assertion messages.
    # These files similar to cpython's bytecode files but are never laoded
    # by python interpreter directly. We remove them for a few reasons:
    # - files are non-deterministic: https://github.com/NixOS/nixpkgs/issues/139292
    #   (file headers are generatedt by pytest directly and contain timestamps)
    # - files are not needed after tests are finished
    pytestRemoveBytecodePhase () {
        # suffix is defined at:
        #    https://github.com/pytest-dev/pytest/blob/7.2.1/src/_pytest/assertion/rewrite.py#L51-L53
        find $out -name "*-pytest-*.py[co]" -delete
    }
    appendToVar preDistPhases pytestRemoveBytecodePhase
  '';

  pythonImportsCheck = [ "pytest" ];

  meta = {
    changelog = "https://github.com/pytest-dev/pytest/blob/${src.tag}/doc/en/changelog.rst";
    description = "Framework for writing tests";
    homepage = "https://docs.pytest.org";
    license = lib.licenses.mit;
    mainProgram = "pytest";
    teams = [ lib.teams.python ];
  };
}
