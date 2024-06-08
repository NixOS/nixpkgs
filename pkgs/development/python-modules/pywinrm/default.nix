{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  mock,
  pytestCheckHook,
  requests,
  requests-ntlm,
  six,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "pywinrm";
  version = "0.4.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mVZ0v1rGSyViycVlQEcxCeUw02veEMJi1aUpYSGtVWU=";
  };

  propagatedBuildInputs = [
    requests
    requests-ntlm
    six
    xmltodict
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "winrm" ];

  pytestFlagsArray = [ "winrm/tests/" ];

  meta = with lib; {
    description = "Python library for Windows Remote Management";
    homepage = "https://github.com/diyan/pywinrm";
    license = licenses.mit;
    maintainers = with maintainers; [
      elasticdog
      kamadorueda
    ];
  };
}
