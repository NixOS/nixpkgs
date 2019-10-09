{ stdenv, buildPythonPackage, pythonOlder, fetchPypi, attrs, hypothesis, py
, setuptools_scm, setuptools, six, pluggy, funcsigs, isPy3k, more-itertools
, atomicwrites, mock, writeText, pathlib2, wcwidth, packaging, isPyPy, python
}:
buildPythonPackage rec {
  version = "5.1.0";
  pname = "pytest";

  disabled = !isPy3k;

  preCheck = ''
    # don't test bash builtins
    rm testing/test_argcomplete.py
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "3805d095f1ea279b9870c3eeae5dddf8a81b10952c8835cd628cf1875b0ef031";
  };

  checkInputs = [ hypothesis mock ];
  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ attrs py setuptools six pluggy more-itertools atomicwrites wcwidth packaging ]
    ++ stdenv.lib.optionals (pythonOlder "3.6") [ pathlib2 ];

  doCheck = !isPyPy; # https://github.com/pytest-dev/pytest/issues/3460

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
    homepage = https://docs.pytest.org;
    description = "Framework for writing tests";
    maintainers = with maintainers; [ domenkozar lovek323 madjar lsix ];
    license = licenses.mit;
  };
}
