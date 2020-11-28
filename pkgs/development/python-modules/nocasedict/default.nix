{ lib, buildPythonPackage, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "nocasedict";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bl1b0R3jP5PSJUXZ7SOguY+EDyzawNdJ0vqkYXrcd3I=";
  };

  checkInputs = [
    pytest
  ];

  pythonImportsCheck = [
    "nocasedict"
  ];

  meta = with lib; {
    description = "A case-insensitive ordered dictionary for Python";
    homepage = "https://github.com/pywbem/nocasedict";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ freezeboy ];
  };
}
