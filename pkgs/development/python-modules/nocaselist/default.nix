{ lib, buildPythonPackage, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "nocaselist";
  version = "1.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4cEsoq6dNFs0lI8sj2DjiUYZ4r4u0otOzF5/HeoRfR0=";
  };

  checkInputs = [
    pytest
  ];

  pythonImportsCheck = [
    "nocaselist"
  ];

  meta = with lib; {
    description = "A case-insensitive list for Python";
    homepage = "https://github.com/pywbem/nocaselist";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ freezeboy ];
  };
}
