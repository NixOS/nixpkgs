{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, deprecated
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jwcrypto";
<<<<<<< HEAD
  version = "1.5.0";
=======
  version = "1.4.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-LB3FHPjjjd8yR5Xf6UJt7p3UbK9H9TXMvBh4H7qBC40=";
=======
    hash = "sha256-gKNentGzssQ84D2SxdSObQtmR+KqJhjkljRIkj14o3s=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/latchset/jwcrypto/releases/tag/v${version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ ];
=======
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
