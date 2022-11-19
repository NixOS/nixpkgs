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
, setuptools
}:

buildPythonPackage rec {
  pname = "pyspnego";
  version = "0.6.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jborean93";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Nc15ULqvD7BSd78iDay1gMkKepJn/cBLBVYR8Lw15Z8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    cryptography
  ];

  passthru.optional-dependencies = {
    kerberos = [
      gssapi
      krb5
    ];
    yaml = [
      ruamel-yaml
    ];
  };

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

  pythonImportsCheck = [
    "spnego"
  ];

  meta = with lib; {
    description = "Python SPNEGO authentication library";
    homepage = "https://github.com/jborean93/pyspnego";
    changelog = "https://github.com/jborean93/pyspnego/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
