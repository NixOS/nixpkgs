{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, google-auth
, google-auth-oauthlib
, pytest-vcr
, pytestCheckHook
, pythonOlder
, strenum
}:

buildPythonPackage rec {
  pname = "gspread";
  version = "6.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "burnash";
    repo = "gspread";
    rev = "refs/tags/v${version}";
    hash = "sha256-kuXPX+VY0qz4fldGYPbzZMFx+blzsmueews1W+AjQb0=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    google-auth
    google-auth-oauthlib
    strenum
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
