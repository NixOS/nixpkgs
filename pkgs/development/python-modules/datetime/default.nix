{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytz
, zope_interface
}:

buildPythonPackage rec {
  pname = "datetime";
<<<<<<< HEAD
  version = "5.2";
=======
  version = "5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "datetime";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-J96IjyPyJaUC5mECK3g/cgxBh1OoVfj62XocBatYgOw=";
=======
    hash = "sha256-5H7s2y/2zsQC3Azs1yakotO8ZVLCRV8yPahbX09C5L8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    pytz
    zope_interface
  ];

  pythonImportsCheck = [
    "DateTime"
  ];

  meta = with lib; {
    description = "DateTime data type, as known from Zope";
    homepage = "https://github.com/zopefoundation/DateTime";
<<<<<<< HEAD
    changelog = "https://github.com/zopefoundation/DateTime/blob/${version}/CHANGES.rst";
=======
    changelog = "https://github.com/zopefoundation/DateTime/releases/tag/${version}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.zpl21;
    maintainers = with maintainers; [ icyrockcom ];
  };
}

