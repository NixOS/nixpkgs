{
  lib,
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
  version = "0.2.28";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "oras-project";
    repo = "oras-py";
    tag = version;
    hash = "sha256-JUKInJDBR9Qnqg04FDG2SlktSRRWCf30+96tDuhYc1Y=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jsonschema
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

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
