{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  six,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "imapclient";
  version = "3.1.0";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mjs";
    repo = "imapclient";
    tag = version;
    hash = "sha256-J+pB+jXAoZItvaR8o+97sETFYxWj+uslmvsAe/Q0Gzc=";
  };

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "imapclient"
    "imapclient.response_types"
    "imapclient.exceptions"
    "imapclient.testable_imapclient"
    "imapclient.tls"
  ];

  meta = {
    homepage = "https://imapclient.readthedocs.io";
    description = "Easy-to-use, Pythonic and complete IMAP client library";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      almac
      dotlambda
    ];
  };
}
