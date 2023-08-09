{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, http-sfv
, pytestCheckHook
, pythonOlder
, setuptools-scm
, requests
}:

buildPythonPackage rec {
  pname = "http-message-signatures";
  version = "0.4.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pyauth";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-acTziJM5H5Td+eG/LNrlNwgpVvFDyl/tf6//YuE1XZk=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    cryptography
    http-sfv
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests
  ];

  pytestFlagsArray = [
    "test/test.py"
  ];

  pythonImportsCheck = [
    "http_message_signatures"
  ];

  meta = with lib; {
    description = "Requests authentication module for HTTP Signature";
    homepage = "https://github.com/pyauth/http-message-signatures";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
