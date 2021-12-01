{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, gssapi
, krb5
, ruamel-yaml
, pytest-mock
, pytestCheckHook
, pythonOlder
, glibcLocales
}:

buildPythonPackage rec {
  pname = "pyspnego";
  version = "0.3.1";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jborean93";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-f7CR7wMxHNNpxizV7MFCtWci3SSNvdx+W5i/rgOUSxY=";
  };

  propagatedBuildInputs = [
    cryptography
    gssapi
    krb5
    ruamel-yaml
  ];

  checkInputs = [
    glibcLocales
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = [
    # struct.error: unpack requires a buffer of 1 bytes
    "test_credssp_invalid_client_authentication"
  ];

  LC_ALL = "en_US.UTF-8";

  pythonImportsCheck = [ "spnego" ];

  meta = with lib; {
    description = "Python SPNEGO authentication library";
    homepage = "Python SPNEGO authentication library";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
