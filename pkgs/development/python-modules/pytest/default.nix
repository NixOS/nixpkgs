{ lib, buildPythonPackage, pythonOlder, fetchPypi, isPy3k, isPyPy
, atomicwrites
, attrs
, hypothesis
, iniconfig
, more-itertools
, packaging
, pathlib2
, pluggy
, py
, pygments
, setuptools
, setuptools-scm
, six
, toml
, wcwidth
, writeText
}:

buildPythonPackage rec {
  pname = "pytest";
  version = "6.2.4";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "50bcad0a0b9c5a72c8e4e7c9855a3ad496ca6a881a3641b4260605450772c54b";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    atomicwrites
    attrs
    iniconfig
    more-itertools
    packaging
    pluggy
    py
    setuptools
    six
    toml
    wcwidth
  ] ++ lib.optionals (pythonOlder "3.6") [ pathlib2 ];

  checkInputs = [
    hypothesis
    pygments
  ];

  doCheck = !isPyPy; # https://github.com/pytest-dev/pytest/issues/3460

  preCheck = ''
    # don't test bash builtins
    rm testing/test_argcomplete.py
  '';

  # Ignored file https://github.com/pytest-dev/pytest/pull/5605#issuecomment-522243929
  # test_missing_required_plugins will emit deprecation warning which is treated as error
  checkPhase = ''
    runHook preCheck
    $out/bin/py.test -x testing/ \
      --ignore=testing/test_junitxml.py \
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
