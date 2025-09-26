{
  lib,
  buildPythonPackage,
  fetchPypi,
  mock,
  pykerberos,
  pytestCheckHook,
  pythonOlder,
  requests-credssp,
  requests-ntlm,
  requests,
  setuptools,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "pywinrm";
  version = "0.5.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VCjrHklK95VFRs1P8Vye8aMKdeBbJaOf1gbO8iIB6fE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    requests-ntlm
    xmltodict
  ];

  optional-dependencies = {
    credssp = [ requests-credssp ];
    kerberos = [ pykerberos ];
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "winrm" ];

  enabledTestPaths = [ "winrm/tests/" ];

  meta = with lib; {
    description = "Python library for Windows Remote Management";
    homepage = "https://github.com/diyan/pywinrm";
    changelog = "https://github.com/diyan/pywinrm/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      elasticdog
      kamadorueda
    ];
  };
}
