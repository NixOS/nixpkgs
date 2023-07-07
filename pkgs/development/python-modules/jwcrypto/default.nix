{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, deprecated
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jwcrypto";
  version = "1.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LB3FHPjjjd8yR5Xf6UJt7p3UbK9H9TXMvBh4H7qBC40=";
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
    changelog = "https://github.com/latchset/jwcrypto/releases/tag/v${version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ costrouc ];
  };
}
