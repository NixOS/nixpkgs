{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  pydantic,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pycfmodel";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Skyscanner";
    repo = "pycfmodel";
    tag = "v${version}";
    hash = "sha256-ta6kS+MiSa2DZx18EQr7hvWYrK55j48hSBACtcklCpI=";
  };

  pythonRelaxDeps = [ "pydantic" ];

  build-system = [ setuptools ];

  dependencies = [ pydantic ];

  nativeCheckInputs = [
    httpx
    pytestCheckHook
  ];

  disabledTests = [
    # Test require network access
    "test_cloudformation_actions"
    "test_auxiliar_cast"
    "test_valid_es_domain_from_aws_documentation_examples_resource_can_be_built"
    "test_valid_opensearch_domain_from_aws_documentation_examples_resource_can_be_built"
    "test_resolve_booleans_different_properties_for_generic_resource"
    "test_loose_ip"
    "test_extra_fields_not_allowed_s3_bucket"
    "test_raise_error_if_invalid_fields_in_resource"
  ];

  pythonImportsCheck = [ "pycfmodel" ];

  meta = {
    description = "Model for Cloud Formation scripts";
    homepage = "https://github.com/Skyscanner/pycfmodel";
    changelog = "https://github.com/Skyscanner/pycfmodel/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
