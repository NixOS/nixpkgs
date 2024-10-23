{
  lib,
  python3,
  fetchFromGitHub,
}:

let
  py = python3 // {
    pkgs = python3.pkgs.overrideScope (
      final: prev: {
        urllib3 = prev.urllib3.overridePythonAttrs (prev: rec {
          pyproject = true;
          nativeBuildInputs = [ final.setuptools ];
          version = "1.26.19";
          src = prev.src.override {
            inherit version;
            hash = "sha256-Pj11OoYYuG194zO0IjAF9ocgvNan0ry5+9IinsfB5Ck=";
          };
        });
      }
    );
  };
in
py.pkgs.buildPythonPackage rec {
  name = "marqo";
  version = "3.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marqo-ai";
    repo = "py-marqo";
    rev = "refs/tags/${version}";
    hash = "sha256-qwGSw6NJJzay1hvSKIkV7ONlrxut196j2pQRCWYI3YI=";
  };

  build-system = with py.pkgs; [ setuptools ];

  nativeCheckInputs = with py.pkgs; [ pytestCheckHook ];

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

  dependencies = with py.pkgs; [
    requests
    packaging
    pip
    setuptools
    urllib3
    pydantic
    requests-mock
  ];

  optional-dependencies = {
    tests = with py.pkgs; [
      numpy
      pillow
      dataclasses-json
    ];
  };

  pythonImportsCheck = [ "marqo" ];

  meta = with lib; {
    description = "Unified embedding generation and search engine.";
    homepage = "https://marqo.ai";
    license = licenses.asl20;
    maintainers = with maintainers; [ naufik ];
  };
}
