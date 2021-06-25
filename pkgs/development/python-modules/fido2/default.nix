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
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8680ee25238e2307596eb3900a0f8c0d9cc91189146ed8039544f1a3a69dfe6e";
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
