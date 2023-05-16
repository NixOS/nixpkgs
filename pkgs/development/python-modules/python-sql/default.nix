{ lib
, fetchPypi
, buildPythonPackage
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python-sql";
<<<<<<< HEAD
  version = "1.4.2";
=======
  version = "1.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-stuHXGcgwblayCyD6lLOu5RMQHvmii7wN8zdi6ucxTw=";
=======
    hash = "sha256-b+dkCC9IiR2Ffqfm+kJfpU8TUx3fa4nyTAmOZGrRtLY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sql"
  ];

  meta = with lib; {
    description = "Library to write SQL queries in a pythonic way";
<<<<<<< HEAD
    homepage = "https://foss.heptapod.net/tryton/python-sql";
    changelog = "https://foss.heptapod.net/tryton/python-sql/-/blob/${version}/CHANGELOG";
=======
    homepage = "https://pypi.org/project/python-sql/";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd3;
    maintainers = with maintainers; [ johbo ];
  };
}
