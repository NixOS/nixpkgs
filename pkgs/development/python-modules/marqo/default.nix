{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  requests,
  packaging,
  pydantic,
  typing-extensions,
  requests-mock,
}:

buildPythonPackage rec {
  name = "marqo";
  version = "3.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marqo-ai";
    repo = "py-marqo";
    rev = "refs/tags/${version}";
    hash = "sha256-phO7aR7kQJHw5qxrpMI5DtOaXlaHMsKfaC3UquyD/Rw=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
    typing-extensions
  ];

  disabledTestPaths = [
    # Tests require network
    "tests/v2_tests/test_tensor_search.py"
    "tests/v2_tests/test_client.py"
    "tests/v2_tests/test_get_settings.py"
    "tests/v2_tests/test_tensor_search.py"
    "tests/v2_tests/test_add_documents.py"
    "tests/v2_tests/test_delete_documents.py"
    "tests/v2_tests/test_demos.py"
    "tests/v2_tests/test_custom_vector_search.py"
    "tests/v2_tests/test_create_index.py"
    "tests/v2_tests/test_image_chunking.py"
    "tests/v2_tests/test_telemetry.py"
    "tests/v2_tests/test_score_modifier_search.py"
    "tests/v2_tests/test_model_cache_management.py"
    "tests/v2_tests/test_embed.py"
    "tests/v2_tests/test_index_init_logging.py"
    "tests/v2_tests/test_marqo_cloud_instance_mapping.py"
    "tests/v2_tests/test_index_manipulation_features.py"
    "tests/v2_tests/test_index.py"
    "tests/v2_tests/test_get_indexes.py"
    "tests/v2_tests/test_hybrid_search.py"
    "tests/v2_tests/test_logging.py"
    "tests/v2_tests/test_recommend.py"
  ];

  dependencies = [
    packaging
    pydantic
    requests
  ];

  pythonRemoveDeps = [ "urllib3" ];

  pythonImportsCheck = [ "marqo" ];

  meta = with lib; {
    description = "Unified embedding generation and search engine";
    homepage = "https://marqo.ai";
    changelog = "https://github.com/marqo-ai/py-marqo/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ naufik ];
  };
}
