{
  lib,
  buildPythonPackage,
  callPackage,
  pythonOlder,
  fetchPypi,
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

let
  self = buildPythonPackage rec {
    pname = "pytest";
    version = "7.4.4";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-LPAAWSLGrOSj4uyLQIDrDZdT/ckxB0FTMvUM6eeZQoA=";
    };

    outputs = [
      "out"
      "testout"
    ];

    nativeBuildInputs = [
      setuptools
      setuptools-scm
    ];

    propagatedBuildInputs = [
      iniconfig
      packaging
      pluggy
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
        pygments
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
    passthru.tests.pytest = callPackage ./tests.nix { pytest = self; };

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

    meta = with lib; {
      description = "Framework for writing tests";
      homepage = "https://docs.pytest.org";
      changelog = "https://github.com/pytest-dev/pytest/releases/tag/${version}";
      maintainers = with maintainers; [
        lovek323
        madjar
      ];
      license = licenses.mit;
    };
  };
in
self
