{
  lib,
  boto3,
  buildPythonPackage,
  fetchFromGitHub,
  jsonschema,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "oras";
  version = "0.2.42";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oras-project";
    repo = "oras-py";
    tag = finalAttrs.version;
    hash = "sha256-fuDvhz7dTsPM1AZkPUUgalXUnslAKqTXplslbOUjS/I=";
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

  meta = {
    description = "ORAS Python SDK";
    homepage = "https://github.com/oras-project/oras-py";
    changelog = "https://github.com/oras-project/oras-py/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
