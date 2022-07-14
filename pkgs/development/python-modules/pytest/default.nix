{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, isPyPy
, writeText

# build
, setuptools-scm

# propagates
, attrs
, iniconfig
, packaging
, pluggy
, py
, tomli

# tests
, hypothesis
, pygments
}:

buildPythonPackage rec {
  pname = "pytest";
  version = "7.1.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-oGoEJUU4ZKJwvEXnH3gzMKdCje+0Iw+15qcx/eBuzUU=";
  };

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
  ];

  checkInputs = [
    hypothesis
    pygments
  ];

  doCheck = !isPyPy; # https://github.com/pytest-dev/pytest/issues/3460

  # Ignored file https://github.com/pytest-dev/pytest/pull/5605#issuecomment-522243929
  # test_missing_required_plugins will emit deprecation warning which is treated as error
  checkPhase = ''
    runHook preCheck
    $out/bin/py.test -x testing/ \
      --ignore=testing/test_junitxml.py \
      --ignore=testing/test_argcomplete.py \
      -k "not test_collect_pyargs_with_testpaths and not test_missing_required_plugins"

    # tests leave behind unreproducible pytest binaries in the output directory, remove:
    find $out/lib -name "*-pytest-${version}.pyc" -delete
    # specifically testing/test_assertion.py and testing/test_assertrewrite.py leave behind those:
    find $out/lib -name "*opt-2.pyc" -delete

    runHook postCheck
  '';

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
        #    https://github.com/pytest-dev/pytest/blob/7.1.2/src/_pytest/assertion/rewrite.py#L51-L53
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
