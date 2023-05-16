{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, pytestCheckHook
, numpy
, pandas
, pytz
}:

buildPythonPackage rec {
  pname = "json-tricks";
<<<<<<< HEAD
  version = "3.17.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "3.15.5";
  disabled = pythonOlder "3.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mverleg";
    repo = "pyjson_tricks";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-xddMc4PvVI+mqB3eeVqECZmdeSKAURsdbOnUAXahqM0=";
  };

  nativeCheckInputs = [
    numpy
    pandas
    pytz
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "json_tricks"
  ];
=======
    rev = "v${version}";
    sha256 = "wdpqCqMO0EzKyqE4ishL3CTsSw3sZPGvJ0HEktKFgZU=";
  };

  nativeCheckInputs = [ numpy pandas pytz pytestCheckHook ];

  pythonImportsCheck = [ "json_tricks" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Extra features for Python JSON handling";
    homepage = "https://github.com/mverleg/pyjson_tricks";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
