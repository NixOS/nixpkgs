{ stdenv, buildPythonPackage, fetchPypi, attrs, hypothesis, py
, setuptools_scm, setuptools, six, pluggy, funcsigs, isPy3k, more-itertools
, atomicwrites, mock, writeText, pathlib2
}:
buildPythonPackage rec {
  version = "3.7.1";
  pname = "pytest";

  preCheck = ''
    # don't test bash builtins
    rm testing/test_argcomplete.py
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "86a8dbf407e437351cef4dba46736e9c5a6e3c3ac71b2e942209748e76ff2086";
  };

  checkInputs = [ hypothesis mock ];
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ attrs py setuptools six pluggy more-itertools atomicwrites]
    ++ stdenv.lib.optionals (!isPy3k) [ funcsigs pathlib2 ];

  checkPhase = ''
    runHook preCheck
    $out/bin/py.test -x testing/
    runHook postCheck
  '';

  # Remove .pytest_cache when using py.test in a Nix build
  setupHook = writeText "pytest-hook" ''
    postFixupHooks+=(
        'find $out -name .pytest_cache -type d -exec rm -rf {} +'
    )
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ domenkozar lovek323 madjar lsix ];
    platforms = platforms.unix;
    description = "Framework for writing tests";
  };
}
