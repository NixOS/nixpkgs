{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, deprecated
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jwcrypto";
  version = "1.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MLz8LRmfLxpS0EVY/6mREq2B17eH8p4NmqTvSZk0MH4=";
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
