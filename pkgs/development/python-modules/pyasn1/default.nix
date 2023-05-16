{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyasn1";
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-l7cpDKaOYqgyVY7Dl28Vy/kRv118cDnYuGHCoOzmn94=";
  };

  pythonImportsCheck = [
    "pyasn1"
  ];

  meta = with lib; {
    description = "Generic ASN.1 library for Python";
    homepage = "https://pyasn1.readthedocs.io";
    changelog = "https://github.com/etingof/pyasn1/blob/master/CHANGES.rst";
    license = licenses.bsd2;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
