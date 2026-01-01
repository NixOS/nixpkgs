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
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (builtins.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  pythonImportsCheck = [ "winrm" ];

  enabledTestPaths = [ "winrm/tests/" ];

<<<<<<< HEAD
  meta = {
    description = "Python library for Windows Remote Management";
    homepage = "https://github.com/diyan/pywinrm";
    changelog = "https://github.com/diyan/pywinrm/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Python library for Windows Remote Management";
    homepage = "https://github.com/diyan/pywinrm";
    changelog = "https://github.com/diyan/pywinrm/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      elasticdog
      kamadorueda
    ];
  };
}
