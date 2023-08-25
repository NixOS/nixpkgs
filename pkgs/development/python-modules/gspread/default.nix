{ lib
, buildPythonPackage
, fetchFromGitHub
, flitBuildHook
, google-auth
, google-auth-oauthlib
, pytest-vcr
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "gspread";
  version = "5.10.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "burnash";
    repo = "gspread";
    rev = "refs/tags/v${version}";
    hash = "sha256-GAlQYQVuwsnkXqZOvG66f9kig+m392CVlrgUTqrTKyA=";
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
