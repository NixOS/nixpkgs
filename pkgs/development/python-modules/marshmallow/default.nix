{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, pytz
, simplejson
, packaging
}:

buildPythonPackage rec {
  pname = "marshmallow";
<<<<<<< HEAD
  version = "3.20.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";
=======
  version = "3.19.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-sPYiup7ontnubtBxv+rIT0up4IHPJNCUlH9J4FlHsss=";
=======
    rev = version;
    hash = "sha256-b1brLHM48t45bwUXk7QreLLmvTzU0sX7Uoc1ZAgGkrE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytz
    simplejson
  ];

  pythonImportsCheck = [
    "marshmallow"
  ];

  meta = with lib; {
<<<<<<< HEAD
    description = "Library for converting complex objects to and from simple Python datatypes";
    homepage = "https://github.com/marshmallow-code/marshmallow";
    changelog = "https://github.com/marshmallow-code/marshmallow/blob/${version}/CHANGELOG.rst";
=======
    changelog = "https://github.com/marshmallow-code/marshmallow/blob/${src.rev}/CHANGELOG.rst";
    description = "Library for converting complex objects to and from simple Python datatypes";
    homepage = "https://github.com/marshmallow-code/marshmallow";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ cript0nauta ];
  };
}
