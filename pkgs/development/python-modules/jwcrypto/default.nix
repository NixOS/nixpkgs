{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, deprecated
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jwcrypto";
  version = "1.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VLVRsRX/tNErHx7pO4uipxu4VWuj2F1i9wdUlhPah3w=";
  };

  propagatedBuildInputs = [
    cryptography
    deprecated
  ];

  pythonImportsCheck = [
    "jwcrypto"
  ];

  meta = with lib; {
    description = "Implementation of JOSE Web standards";
    homepage = "https://github.com/latchset/jwcrypto";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ costrouc ];
  };
}
