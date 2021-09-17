{ lib, buildPythonPackage, pythonOlder, fetchPypi, attrs, hypothesis, py
, setuptools-scm, setuptools, six, pluggy, funcsigs, isPy3k, more-itertools
, atomicwrites, mock, writeText, pathlib2, wcwidth, packaging, isPyPy
}:
buildPythonPackage rec {
  version = "4.6.11";
  pname = "pytest";

  src = fetchPypi {
    inherit pname version;
    sha256 = "50fa82392f2120cc3ec2ca0a75ee615be4c479e66669789771f1758332be4353";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pluggy>=0.12,<1.0" "pluggy>=0.12,<2.0"
  '';

  checkInputs = [ hypothesis mock ];
  buildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ attrs py setuptools six pluggy more-itertools atomicwrites wcwidth packaging ]
    ++ lib.optionals (!isPy3k) [ funcsigs ]
    ++ lib.optionals (pythonOlder "3.6") [ pathlib2 ];

  doCheck = !isPyPy; # https://github.com/pytest-dev/pytest/issues/3460
  checkPhase = ''
    runHook preCheck

    # don't test bash builtins
    rm testing/test_argcomplete.py

    # determinism - this test writes non deterministic bytecode
    rm -rf testing/test_assertrewrite.py

    PYTHONDONTWRITEBYTECODE=1 $out/bin/py.test -x testing/ -k "not test_collect_pyargs_with_testpaths"
    runHook postCheck
  '';

  # Remove .pytest_cache when using py.test in a Nix build
  setupHook = writeText "pytest-hook" ''
    pytestcachePhase() {
        find $out -name .pytest_cache -type d -exec rm -rf {} +
    }

    preDistPhases+=" pytestcachePhase"
  '';

  meta = with lib; {
    homepage = "https://docs.pytest.org";
    description = "Framework for writing tests";
    maintainers = with maintainers; [ domenkozar lovek323 madjar lsix ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
