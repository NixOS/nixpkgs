{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pyspnego,
  pytestCheckHook,
  requests,
}:

buildPythonPackage rec {
  pname = "requests-credssp";
  version = "2.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jborean93";
    repo = "requests-credssp";
    rev = "v${version}";
    hash = "sha256-HHLEmQ+mNjMjpR6J+emrKFM+2PiYq32o7Gnoo0gUrNA=";
  };

  propagatedBuildInputs = [
    cryptography
    pyspnego
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  optional-dependencies = {
    kerberos = pyspnego.optional-dependencies.kerberos;
  };

  pythonImportsCheck = [ "requests_credssp" ];

  meta = {
    description = "HTTPS CredSSP authentication with the requests library";
    homepage = "https://github.com/jborean93/requests-credssp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
