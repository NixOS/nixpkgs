{ lib
, buildPythonPackage
, fetchPypi
, numpy
, laszip
<<<<<<< HEAD
, setuptools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "laspy";
<<<<<<< HEAD
  version = "2.5.1";
  format = "pyproject";
=======
  version = "2.4.1";
  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-uqPJxswVVjbxYRSREfnPwkPb0U9synKclLNWsxxmjy4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

=======
    hash = "sha256-E8rsxzJcsiQsslOUmE0hs7X3lsiLy0S8LtLTzxuXKsQ=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    numpy
    laszip
  ];

<<<<<<< HEAD
  nativeCheckInputs = [
=======
  checkInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "laspy"
    "laszip"
  ];

  meta = with lib; {
    description = "Interface for reading/modifying/creating .LAS LIDAR files";
    homepage = "https://github.com/laspy/laspy";
<<<<<<< HEAD
    changelog = "https://github.com/laspy/laspy/blob/${version}/CHANGELOG.md";
=======
    changelog = "https://github.com/laspy/laspy/blob/2.4.1/CHANGELOG.md";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd2;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
