{ stdenv, buildPythonPackage, pythonOlder, fetchPypi, isPy3k, isPyPy
, atomicwrites
, attrs
, funcsigs
, hypothesis
, iniconfig
, mock
, more-itertools
, packaging
, pathlib2
, pluggy
, py
, pygments
, python
, setuptools
, setuptools_scm
, six
, toml
, wcwidth
, writeText
}:

buildPythonPackage rec {
  version = "6.1.2";
  pname = "pytest";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c0a7e94a8cdbc5422a51ccdad8e6f1024795939cc89159a0ae7f0b316ad3823e";
  };

  checkInputs = [ hypothesis pygments ];
  nativeBuildInputs = [ setuptools_scm ];
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
  ] ++ stdenv.lib.optionals (pythonOlder "3.6") [ pathlib2 ];

  doCheck = !isPyPy; # https://github.com/pytest-dev/pytest/issues/3460

  preCheck = ''
    # don't test bash builtins
    rm testing/test_argcomplete.py
  '';

  # Ignored file https://github.com/pytest-dev/pytest/pull/5605#issuecomment-522243929
  checkPhase = ''
    runHook preCheck
    $out/bin/py.test -x testing/ -k "not test_collect_pyargs_with_testpaths" --ignore=testing/test_junitxml.py
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

  meta = with stdenv.lib; {
    homepage = "https://docs.pytest.org";
    description = "Framework for writing tests";
    maintainers = with maintainers; [ domenkozar lovek323 madjar lsix ];
    license = licenses.mit;
  };
}
