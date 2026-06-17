{
  lib,
  buildPythonPackage,
  fetchPypi,
  mock,
  pykerberos,
  pytestCheckHook,
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
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "winrm" ];

  enabledTestPaths = [ "winrm/tests/" ];

  meta = {
    description = "Python library for Windows Remote Management";
    homepage = "https://github.com/diyan/pywinrm";
    changelog = "https://github.com/diyan/pywinrm/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      elasticdog
      kamadorueda
    ];
  };
}
