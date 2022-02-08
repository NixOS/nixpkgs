{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# Python dependencies
, openpyxl
, pandas
, pandas-stubs
, requests
, tqdm

# Check dependencies
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "openai";
  version = "0.14.0";

  disabled = pythonOlder "3.7.1";

  # Use GitHub source since PyPi source does not include tests
  src = fetchFromGitHub {
    owner = "openai";
    repo = "openai-python";
    rev = "v${version}";
    sha256 = "sha256-AFfbMeYxdZaIABhf4XpszhLvFuMJebhl07sv9kuiknA=";
  };

  propagatedBuildInputs = [
    openpyxl
    pandas
    pandas-stubs
    requests
    tqdm
  ];

  pythonImportsCheck = [ "openai" ];
  checkInputs = [ pytestCheckHook pytest-mock ];
  pytestFlagsArray = [ "openai/tests" ];
  OPENAI_API_KEY = "sk-foo";
  disabledTestPaths = [
    "openai/tests/test_endpoints.py" # requires a real API key
    "openai/tests/test_file_cli.py"
  ];

  meta = with lib; {
    description = "Python client library for the OpenAI API";
    homepage = "https://github.com/openai/openai-python";
    license = licenses.mit;
    maintainers = [ maintainers.malo ];
  };
}
