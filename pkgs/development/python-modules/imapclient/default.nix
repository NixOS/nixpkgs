{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "imapclient";
  version = "3.0.0";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mjs";
    repo = "imapclient";
    rev = "refs/tags/${version}";
    hash = "sha256-ylYGh+78I+6pdvHuQPw8Gks9TLkXQL5HQiaZDnJK3DA=";
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

  meta = with lib; {
    homepage = "https://imapclient.readthedocs.io";
    description = "Easy-to-use, Pythonic and complete IMAP client library";
    license = licenses.bsd3;
    maintainers = with maintainers; [ almac dotlambda ];
  };
}
