{ lib
, asyncssh
, buildPythonPackage
, cryptography
, fetchFromGitHub
, gssapi
, httpcore
, httpx
, krb5
, psrpcore
, psutil
, pyspnego
, pytest-mock
, pytestCheckHook
, pythonOlder
, pyyaml
, requests
, requests-credssp
, xmldiff
}:

buildPythonPackage rec {
  pname = "pypsrp";
  version = "0.8.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jborean93";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Pwfc9e39sYPdcHN1cZtxxGEglEYzPp4yOYLD5/4SSiU=";
  };

  propagatedBuildInputs = [
    cryptography
    httpcore
    httpx
    psrpcore
    pyspnego
    requests
  ];

  checkInputs = [
    pytest-mock
    pytestCheckHook
    pyyaml
    xmldiff
  ];

  passthru.optional-dependencies = {
    credssp = [
      requests-credssp
    ];
    kerberos = [
      # pyspnego[kerberos] will have those two dependencies
      gssapi
      krb5
    ];
    named_pipe = [
      psutil
    ];
    ssh = [
      asyncssh
    ];
  };

  pythonImportsCheck = [
    "pypsrp"
  ];

  meta = with lib; {
    description = "PowerShell Remoting Protocol Client library";
    homepage = "https://github.com/jborean93/pypsrp";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
