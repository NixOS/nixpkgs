{ lib, buildPythonPackage, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "nocaselist";
  version = "1.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "73a9c0659e7135c66e46a6ab06e2cb637ce9248d73c690ebd31afb72a4e03ac0";
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
