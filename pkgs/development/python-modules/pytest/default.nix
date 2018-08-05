{ stdenv, buildPythonPackage, fetchPypi, attrs, hypothesis, py
, setuptools_scm, setuptools, six, pluggy, funcsigs, isPy3k, more-itertools
, atomicwrites, mock, writeText
}:
buildPythonPackage rec {
  version = "3.6.3";
  pname = "pytest";

  preCheck = ''
    # don't test bash builtins
    rm testing/test_argcomplete.py
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "0453c8676c2bee6feb0434748b068d5510273a916295fd61d306c4f22fbfd752";
  };

  checkInputs = [ hypothesis mock ];
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ attrs py setuptools six pluggy more-itertools atomicwrites]
    ++ (stdenv.lib.optional (!isPy3k) funcsigs);

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
