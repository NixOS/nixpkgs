{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "imapclient";
  version = "2.3.1";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mjs";
    repo = "imapclient";
    rev = version;
    hash = "sha256-aHWRhQOEjYiLlWTiuYo/a4pOhfLF7jz+ltG+yOqgfKI=";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "imapclient"
    "imapclient.response_types"
    "imapclient.exceptions"
    "imapclient.testable_imapclient"
    "imapclient.tls"
  ];

  meta = with lib; {
    homepage = "https://imapclient.readthedocs.io";
    description = "Easy-to-use, Pythonic and complete IMAP client library";
    license = licenses.bsd3;
    maintainers = with maintainers; [ almac dotlambda ];
  };
}
