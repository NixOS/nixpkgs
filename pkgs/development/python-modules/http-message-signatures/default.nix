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
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pyauth";
    repo = "http-message-signatures";
    tag = "v${version}";
    hash = "sha256-vPZeAS3hR7Bmj2FtME+V9WU3TViBndrBb9GLkdMVh2Q=";
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

  enabledTestPaths = [ "test/test.py" ];

  pythonImportsCheck = [ "http_message_signatures" ];

  meta = with lib; {
    description = "Requests authentication module for HTTP Signature";
    homepage = "https://github.com/pyauth/http-message-signatures";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
