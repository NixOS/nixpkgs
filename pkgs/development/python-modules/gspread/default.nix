{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  google-auth,
  google-auth-oauthlib,
  pytest-vcr,
  pytestCheckHook,
  strenum,
}:

buildPythonPackage rec {
  pname = "gspread";
  version = "6.2.1";
  pyproject = true;

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

  meta = {
    description = "Google Spreadsheets client library";
    homepage = "https://github.com/burnash/gspread";
    changelog = "https://github.com/burnash/gspread/blob/${src.tag}/HISTORY.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
