{ lib
, fetchPypi
, buildPythonPackage
, editorconfig
, pytestCheckHook
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "jsbeautifier";
<<<<<<< HEAD
  version = "1.14.9";
=======
  version = "1.14.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-xzjrw2tHvZTkym3RepAEw8x07a1YLKHWDg5dWUWmPLk=";
=======
    hash = "sha256-d5kyVNsf9vhOtuHXXjtrcsui7yCBOlhbLYHo5ePHE8Y=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    editorconfig
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "jsbeautifier"
  ];

  pytestFlagsArray = [
    "jsbeautifier/tests/testindentation.py"
  ];

  meta = with lib; {
    description = "JavaScript unobfuscator and beautifier";
    homepage = "http://jsbeautifier.org";
<<<<<<< HEAD
    changelog = "https://github.com/beautify-web/js-beautify/blob/v${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ apeyroux ];
  };
}
