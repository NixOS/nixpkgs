{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  google-auth,
  google-auth-oauthlib,
  pytest-vcr,
  pytestCheckHook,
  pythonOlder,
  strenum,
}:

buildPythonPackage rec {
  pname = "gspread";
  version = "6.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "burnash";
    repo = "gspread";
    tag = "v${version}";
    hash = "sha256-DTKSH8FtzOXlB7TzNqahDm8PY3ZarpZg8GYQ1kcdfdg=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    google-auth
    google-auth-oauthlib
    strenum
  ];

  nativeCheckInputs = [
    pytest-vcr
    pytestCheckHook
  ];

  pythonImportsCheck = [ "gspread" ];

  meta = with lib; {
    description = "Google Spreadsheets client library";
    homepage = "https://github.com/burnash/gspread";
    changelog = "https://github.com/burnash/gspread/blob/${src.tag}/HISTORY.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
