{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, python
, typing-extensions
}:

buildPythonPackage rec {
  pname = "awacs";
<<<<<<< HEAD
  version = "2.4.0";
=======
  version = "2.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-iflg6tjqFl1gWOzlJhQwGHhAQ/pKm9n8GVvUz6fSboM=";
=======
    hash = "sha256-0tizZWcHe1qbLxpXS/IngExaFFUHZyXXlksWcNL/vEw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = lib.lists.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  pythonImportsCheck = [
    "awacs"
  ];

  meta = with lib; {
    description = "AWS Access Policy Language creation library";
    homepage = "https://github.com/cloudtools/awacs";
    changelog = "https://github.com/cloudtools/awacs/blob/${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jlesquembre ];
  };
}
