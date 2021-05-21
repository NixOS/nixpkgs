{ lib
, buildPythonPackage
, fetchPypi
, unittest2
}:

buildPythonPackage rec {
  pname = "contextlib2";
  version = "0.6.0.post1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01f490098c18b19d2bd5bb5dc445b2054d2fa97f09a4280ba2c5f3c394c8162e";
  };

  checkInputs = [ unittest2 ];

  # pytest based tests fail with:
  #   TypeError: 'NoneType' object is not callable
  checkPhase = ''
    runHook preCheck

    python setup.py test

    runHook postCheck
  '';

  meta = {
    description = "Backports and enhancements for the contextlib module";
    homepage = "https://contextlib2.readthedocs.org/";
    license = lib.licenses.psfl;
  };
}
