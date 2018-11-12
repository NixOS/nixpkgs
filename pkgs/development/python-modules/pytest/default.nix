{ stdenv, buildPythonPackage, pythonOlder, fetchPypi, attrs, hypothesis, py
, setuptools_scm, setuptools, six, pluggy, funcsigs, isPy3k, more-itertools
, atomicwrites, mock, writeText, pathlib2
}:
buildPythonPackage rec {
  version = "3.9.3";
  pname = "pytest";

  preCheck = ''
    # don't test bash builtins
    rm testing/test_argcomplete.py
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "a9e5e8d7ab9d5b0747f37740276eb362e6a76275d76cebbb52c6049d93b475db";
  };

  checkInputs = [ hypothesis mock ];
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ attrs py setuptools six pluggy more-itertools atomicwrites]
    ++ stdenv.lib.optionals (!isPy3k) [ funcsigs ]
    ++ stdenv.lib.optionals (pythonOlder "3.6") [ pathlib2 ];

  checkPhase = ''
    runHook preCheck
    $out/bin/py.test -x testing/
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
