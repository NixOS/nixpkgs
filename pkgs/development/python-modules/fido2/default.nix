{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, cryptography
, mock
, pyfakefs
}:

buildPythonPackage rec {
  pname = "fido2";
  version = "0.9.3";

  src = fetchFromGitHub {
     owner = "Yubico";
     repo = "python-fido2";
     rev = "0.9.3";
     sha256 = "0wh7d4imdlnxvvdg05xkg2g5lj949g4f00kayh0ywh5a1qgam7b9";
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
