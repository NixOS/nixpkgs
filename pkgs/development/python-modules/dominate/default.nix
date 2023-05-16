{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dominate";
<<<<<<< HEAD
  version = "2.8.0";
=======
  version = "2.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-TJDDvvr4jmErcfSzmve8vviXes+oVc7JVyJaj79QQAc=";
=======
    hash = "sha256-UgEBNgiS6/nQVT9n0341n/kkA9ih4zgUAwUDCIoF2kk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dominate"
  ];

  meta = with lib; {
    description = "Library for creating and manipulating HTML documents using an elegant DOM API";
    homepage = "https://github.com/Knio/dominate/";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
