{ lib
, buildPythonPackage
, callPackage
, pythonOlder
, fetchPypi
, isPyPy
, writeText

# build
, setuptools-scm

# propagates
, attrs
, exceptiongroup
, iniconfig
, packaging
, pluggy
, py
, tomli
}:

buildPythonPackage rec {
  pname = "pytest";
  version = "7.2.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xAFOtA4Q8R81WtTjwvssbG0ZGcc/O1pDPeRwggLK3lk=";
  };

  outputs = [
    "out"
    "testout"
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    attrs
    iniconfig
    packaging
    pluggy
    py
    tomli
  ] ++ lib.optionals (pythonOlder "3.11") [
    exceptiongroup
  ];

  postInstall = ''
    mkdir $testout
    cp -R testing $testout/testing
  '';

  doCheck = false;
  passthru.tests.pytest = callPackage ./tests.nix { };

  # Remove .pytest_cache when using py.test in a Nix build
  setupHook = writeText "pytest-hook" ''
    pytestcachePhase() {
        find $out -name .pytest_cache -type d -exec rm -rf {} +
    }
    preDistPhases+=" pytestcachePhase"

    # pytest generates it's own bytecode files to improve assertion messages.
    # These files similar to cpython's bytecode files but are never laoded
    # by python interpreter directly. We remove them for a few reasons:
    # - files are non-deterministic: https://github.com/NixOS/nixpkgs/issues/139292
    #   (file headers are generatedt by pytest directly and contain timestamps)
    # - files are not needed after tests are finished
    pytestRemoveBytecodePhase () {
        # suffix is defined at:
        #    https://github.com/pytest-dev/pytest/blob/7.2.0/src/_pytest/assertion/rewrite.py#L51-L53
        find $out -name "*-pytest-*.py[co]" -delete
    }
    preDistPhases+=" pytestRemoveBytecodePhase"
  '';

  pythonImportsCheck = [
    "pytest"
  ];

  meta = with lib; {
    description = "Framework for writing tests";
    homepage = "https://docs.pytest.org";
    changelog = "https://github.com/pytest-dev/pytest/releases/tag/${version}";
    maintainers = with maintainers; [ domenkozar lovek323 madjar lsix ];
    license = licenses.mit;
  };
}
