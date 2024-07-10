{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  gssapi,
  krb5,
  pyspnego,
  pytestCheckHook,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "requests-credssp";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jborean93";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-HHLEmQ+mNjMjpR6J+emrKFM+2PiYq32o7Gnoo0gUrNA=";
  };

  propagatedBuildInputs = [
    cryptography
    pyspnego
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  passthru.optional-dependencies = {
    kerberos = [
      # pyspnego[kerberos] will have those two dependencies
      gssapi
      krb5
    ];
  };

  pythonImportsCheck = [ "requests_credssp" ];

  meta = with lib; {
    description = "HTTPS CredSSP authentication with the requests library";
    homepage = "https://github.com/jborean93/requests-credssp";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
