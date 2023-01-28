{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, cython
, nose
}:

buildPythonPackage rec {
  pname = "cchardet";
  version = "2.1.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c428b6336545053c2589f6caf24ea32276c6664cb86db817e03a94c60afa0eaf";
  };

  nativeBuildInputs = [
    cython # pending https://github.com/PyYoshi/cChardet/pull/78 being released to PyPI
  ];

  pythonImportsCheck = [
    "cchardet"
  ];

  nativeCheckInputs = [ nose ];

  # on non x86-64 some charsets are identified as their superset, so we skip these tests (last checked with version 2.1.7)
  preCheck = ''
    cp -R src/tests $TMPDIR
    pushd $TMPDIR
  '' + lib.optionalString (stdenv.hostPlatform.system != "x86_64-linux") ''
    rm $TMPDIR/tests/testdata/th/tis-620.txt  # identified as iso-8859-11, which is fine for all practical purposes
    rm $TMPDIR/tests/testdata/ga/iso-8859-1.txt  # identified as windows-1252, which is fine for all practical purposes
    rm $TMPDIR/tests/testdata/fi/iso-8859-1.txt  # identified as windows-1252, which is fine for all practical purposes
  '';

  checkPhase = ''
    runHook preCheck

    nosetests

    runHook postCheck
  '';

  postCheck = ''
    popd
  '';

  meta = {
    description = "High-speed universal character encoding detector";
    homepage = "https://github.com/PyYoshi/cChardet";
    license = lib.licenses.mpl11;
    maintainers = with lib.maintainers; [ ivan ];
  };
}
