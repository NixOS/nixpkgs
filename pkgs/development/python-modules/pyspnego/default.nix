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
  version = "0.9.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jborean93";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-A0vVpEI8TKelZ96dIqSc01SX1gU3pDUVSOV6jap2WtU=";
  };

  propagatedBuildInputs = [
    cryptography
    gssapi
    krb5
    ruamel-yaml
  ];

  nativeCheckInputs = [
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
    homepage = "https://github.com/jborean93/pyspnego";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
