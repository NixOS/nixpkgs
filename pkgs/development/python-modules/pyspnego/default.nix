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
, setuptools
, glibcLocales
}:

buildPythonPackage rec {
  pname = "pyspnego";
  version = "0.10.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jborean93";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-60aIRrhRynbuuFZzzBhJTlmU74CWuao8jWhr126cPrc=";
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

  pythonImportsCheck = [
    "spnego"
  ];

  nativeCheckInputs = [
    glibcLocales
    pytest-mock
    pytestCheckHook
  ];

  env.LC_ALL = "en_US.UTF-8";

  meta = with lib; {
    changelog = "https://github.com/jborean93/pyspnego/blob/v${version}/CHANGELOG.md";
    description = "Python SPNEGO authentication library";
    homepage = "https://github.com/jborean93/pyspnego";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
