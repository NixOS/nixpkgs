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
  version = "6.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "burnash";
    repo = "gspread";
    tag = "v${version}";
    hash = "sha256-j7UNti5N8c1mjw+1qTPIRCWJ6M4Ur0P9sG1uJnp170M=";
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
