{ lib
, buildPythonPackage
, fetchPypi
, python
, nose
}:

buildPythonPackage rec {
  pname = "cchardet";
  version = "2.1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c428b6336545053c2589f6caf24ea32276c6664cb86db817e03a94c60afa0eaf";
  };

  pythonImportsCheck = [
    "cchardet"
  ];

  checkInputs = [ nose ];

  preCheck = ''
    cp -R src/tests $TMPDIR
    pushd $TMPDIR
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
