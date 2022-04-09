{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, tokenize-rt
}:

buildPythonPackage rec {
  pname = "add-trailing-comma";
  version = "2.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "asottile";
    repo = pname;
    rev = "v${version}";
    sha256 = "RBOL4mM9VciHHNmCTlRBIoXqeln19MKYxgv9p6GCNvU=";
  };

  propagatedBuildInputs = [
    tokenize-rt
  ];

  pythonImportsCheck = [
    "add_trailing_comma"
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A tool (and pre-commit hook) to automatically add trailing commas to calls and literals";
    homepage = "https://github.com/asottile/add-trailing-comma";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
