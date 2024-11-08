{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  http-sfv,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
  requests,
}:

buildPythonPackage rec {
  pname = "http-message-signatures";
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pyauth";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Jsivw4lNA/2oqsOGGx8D4gUPftzuys877A9RXyapnSQ=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    cryptography
    http-sfv
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests
  ];

  pytestFlagsArray = [ "test/test.py" ];

  pythonImportsCheck = [ "http_message_signatures" ];

  meta = with lib; {
    description = "Requests authentication module for HTTP Signature";
    homepage = "https://github.com/pyauth/http-message-signatures";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
