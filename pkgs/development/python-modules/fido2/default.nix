{ lib
, buildPythonPackage
, fetchPypi
, six
, cryptography
, mock
, pyfakefs
}:

buildPythonPackage rec {
  pname = "fido2";
  version = "0.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f491c47bb2d74fa157f9d127a1cbb2753a15939a21e78ba8b0bd323d7d101c61";
  };

  propagatedBuildInputs = [ six cryptography ];

  checkInputs = [ mock pyfakefs ];

  # Testing with `python setup.py test` doesn't work:
  # https://github.com/Yubico/python-fido2/issues/108#issuecomment-763513576
  checkPhase = ''
    runHook preCheck

    python -m unittest discover -v

    runHook postCheck
  '';

  pythonImportsCheck = [ "fido2" ];

  meta = with lib; {
    description = "Provides library functionality for FIDO 2.0, including communication with a device over USB.";
    homepage = "https://github.com/Yubico/python-fido2";
    license = licenses.bsd2;
    maintainers = with maintainers; [ prusnak ];
  };
}
