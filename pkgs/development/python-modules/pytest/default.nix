{ stdenv, buildPythonPackage, pythonOlder, fetchPypi, attrs, hypothesis, py
, setuptools_scm, setuptools, six, pluggy, funcsigs, isPy3k, more-itertools
, atomicwrites, mock, writeText, pathlib2, wcwidth, packaging
}:
buildPythonPackage rec {
  version = "4.6.3";
  pname = "pytest";

  preCheck = ''
    # don't test bash builtins
    rm testing/test_argcomplete.py
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "4a784f1d4f2ef198fe9b7aef793e9fa1a3b2f84e822d9b3a64a181293a572d45";
  };

  checkInputs = [ hypothesis mock ];
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ attrs py setuptools six pluggy more-itertools atomicwrites wcwidth packaging ]
    ++ stdenv.lib.optionals (!isPy3k) [ funcsigs ]
    ++ stdenv.lib.optionals (pythonOlder "3.6") [ pathlib2 ];

  checkPhase = ''
    runHook preCheck
    $out/bin/py.test -x testing/ -k "not test_collect_pyargs_with_testpaths"
    runHook postCheck
  '';

  # Remove .pytest_cache when using py.test in a Nix build
  setupHook = writeText "pytest-hook" ''
    pytestcachePhase() {
        find $out -name .pytest_cache -type d -exec rm -rf {} +
    }

    preDistPhases+=" pytestcachePhase"
  '';

  meta = with stdenv.lib; {
    homepage = https://docs.pytest.org;
    description = "Framework for writing tests";
    maintainers = with maintainers; [ domenkozar lovek323 madjar lsix ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
