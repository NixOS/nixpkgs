{ lib
, buildPythonPackage
, fetchFromGitHub
, jsonpointer
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jsonpatch";
<<<<<<< HEAD
  version = "1.33";
=======
  version = "1.32";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "stefankoegl";
    repo = "python-json-patch";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-JHBB64LExzHQVoFF2xcsqGlNWX/YeEBa1M/TmfeQLWI=";
=======
    rev = "v${version}";
    hash = "sha256-JMGBgYjnjHQ5JpzDwJcR2nVZfzmQ8ZZtcB0GsJ9Q4Jc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    jsonpointer
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "jsonpatch"
  ];

  pytestFlagsArray = [
    "tests.py"
  ];

  meta = with lib; {
    description = "Library to apply JSON Patches according to RFC 6902";
    homepage = "https://github.com/stefankoegl/python-json-patch";
<<<<<<< HEAD
    license = licenses.bsd3;
=======
    license = licenses.bsd2; # "Modified BSD license, says pypi"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ ];
  };
}
