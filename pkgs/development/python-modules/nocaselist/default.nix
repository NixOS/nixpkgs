{ lib, buildPythonPackage, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "nocaselist";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fm3st9hVY7kESRPJCH70tpG8PaTXrR2IlozepAlVMyY=";
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
