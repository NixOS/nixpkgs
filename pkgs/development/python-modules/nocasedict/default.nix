{ lib, buildPythonPackage, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "nocasedict";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "86e2dae49e34de7c31b65b486c8f9aa58b66dc2e8ee9b34c390c6c58885c85a0";
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
