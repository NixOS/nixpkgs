{ lib, buildPythonPackage, pythonOlder, fetchPypi, isPy3k, isPyPy
, atomicwrites
, attrs
, funcsigs
, hypothesis
, mock
, more-itertools
, packaging
, pathlib2
, pluggy
, py
, pygments
, python
, setuptools
, setuptools-scm
, six
, toml
, wcwidth
, writeText
}:

buildPythonPackage rec {
  version = "5.4.3";
  pname = "pytest";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1n67lk8iwlsmfdm8663k8l7isllg1xd3n9p1yla7885szhdk6ybr";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pluggy>=0.12,<1.0" "pluggy>=0.12,<2.0"
  '';

  checkInputs = [ hypothesis pygments ];
  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [
    atomicwrites
    attrs
    more-itertools
    packaging
    pluggy
    py
    setuptools
    six
    toml
    wcwidth
  ] ++ lib.optionals (pythonOlder "3.6") [ pathlib2 ];

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

  meta = with lib; {
    homepage = "https://docs.pytest.org";
    description = "Framework for writing tests";
    maintainers = with maintainers; [ domenkozar lovek323 madjar lsix ];
    license = licenses.mit;
  };
}
