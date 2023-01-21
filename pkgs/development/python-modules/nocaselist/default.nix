{ lib, buildPythonPackage, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "nocaselist";
  version = "1.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SPBn+MuEEkXzTQMSC8G6mQDxOxnLUbzGx77gF/fIdNo=";
  };

  nativeCheckInputs = [
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
