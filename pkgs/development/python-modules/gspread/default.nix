{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, google-auth
, google-auth-oauthlib
, pytest-vcr
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "gspread";
  version = "5.11.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "burnash";
    repo = "gspread";
    rev = "refs/tags/v${version}";
    hash = "sha256-geP01U34HzBSmA8FTTaTMlv508hzGBXFiASjGw3uUmQ=";
  };

  nativeBuildInputs = [
    flit-core
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
