{ lib
, buildPythonPackage
<<<<<<< HEAD
, fetchFromGitHub
, flitBuildHook
, google-auth
, google-auth-oauthlib
, pytest-vcr
, pytestCheckHook
, pythonOlder
, requests
=======
, fetchPypi
, requests
, google-auth
, google-auth-oauthlib
, pythonOlder
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "gspread";
<<<<<<< HEAD
  version = "5.11.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "burnash";
    repo = "gspread";
    rev = "refs/tags/v${version}";
    hash = "sha256-a8A47il9NrMdHkSX4YmQj4VIAYDXK5V+FUdwv+LGIfQ=";
  };

  nativeBuildInputs = [
    flitBuildHook
  ];

  propagatedBuildInputs = [
    google-auth
    google-auth-oauthlib
    requests
  ];

  nativeCheckInputs = [
    pytest-vcr
    pytestCheckHook
  ];
=======
  version = "5.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+XOeK4Odf6H4pfDPDU7mjHduL79L/jFnrS6RC9WI+0Q=";
  };

  propagatedBuildInputs = [
    requests
    google-auth
    google-auth-oauthlib
  ];

  # No tests included
  doCheck = false;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  pythonImportsCheck = [
    "gspread"
  ];

  meta = with lib; {
    description = "Google Spreadsheets client library";
    homepage = "https://github.com/burnash/gspread";
    changelog = "https://github.com/burnash/gspread/blob/v${version}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
