{ stdenv, buildPythonPackage, fetchPypi, attrs, hypothesis, py
, setuptools_scm, setuptools, six, pluggy, funcsigs, isPy3k, more-itertools
, atomicwrites, mock, writeText, pathlib2
}:
buildPythonPackage rec {
  version = "3.7.2";
  pname = "pytest";

  preCheck = ''
    # don't test bash builtins
    rm testing/test_argcomplete.py
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "3459a123ad5532852d36f6f4501dfe1acf4af1dd9541834a164666aa40395b02";
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
