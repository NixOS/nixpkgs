{ buildPythonPackage
, isPyPy
, pytest
, hypothesis
, pygments
}:

buildPythonPackage rec {
  pname = "pytest-tests";
  inherit (pytest) version;

  src = pytest.testout;

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    hypothesis
    pygments
  ];

  doCheck = !isPyPy; # https://github.com/pytest-dev/pytest/issues/3460

  # Ignored file https://github.com/pytest-dev/pytest/pull/5605#issuecomment-522243929
  # test_missing_required_plugins will emit deprecation warning which is treated as error
  checkPhase = ''
    runHook preCheck
    ${pytest.out}/bin/py.test -x testing/ \
      --ignore=testing/test_junitxml.py \
      --ignore=testing/test_argcomplete.py \
      -k "not test_collect_pyargs_with_testpaths and not test_missing_required_plugins"

    # tests leave behind unreproducible pytest binaries in the output directory, remove:
    find $out/lib -name "*-pytest-${version}.pyc" -delete
    # specifically testing/test_assertion.py and testing/test_assertrewrite.py leave behind those:
    find $out/lib -name "*opt-2.pyc" -delete

    runHook postCheck
  '';
}
