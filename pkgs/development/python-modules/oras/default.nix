{
  lib,
  boto3,
  buildPythonPackage,
  fetchFromGitHub,
  jsonschema,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "oras";
  version = "0.2.37";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "oras-project";
    repo = "oras-py";
    tag = version;
    hash = "sha256-pXIA970QBIlbFVFpN1Yl71ojc+atdXQuNoPEW+PrrWc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jsonschema
    requests
  ];

  nativeCheckInputs = [
    boto3
    pytestCheckHook
  ];

  pythonImportsCheck = [ "oras" ];

  disabledTests = [
    # Test requires network access
    "test_get_many_tags"
    "test_ssl"
  ];

  meta = with lib; {
    description = "ORAS Python SDK";
    homepage = "https://github.com/oras-project/oras-py";
    changelog = "https://github.com/oras-project/oras-py/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
