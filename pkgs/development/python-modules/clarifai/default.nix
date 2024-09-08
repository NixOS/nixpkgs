{
  lib,
  buildPythonPackage,
  clarifai-grpc,
  fetchFromGitHub,
  inquirerpy,
  numpy,
  pillow,
  pycocotools,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  rich,
  schema,
  setuptools,
  tabulate,
  tqdm,
  tritonclient,
}:

buildPythonPackage rec {
  pname = "clarifai";
  version = "10.8.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Clarifai";
    repo = "clarifai-python";
    rev = "refs/tags/${version}";
    hash = "sha256-dRhFZACfdMW0cIBDVUOSGDl5fai0gFXDPyfDil+itwQ=";
  };

  pythonRelaxDeps = [
    "clarifai-grpc"
    "schema"
  ];

  build-system = [ setuptools ];

  dependencies = [
    clarifai-grpc
    inquirerpy
    numpy
    pillow
    pyyaml
    rich
    schema
    tabulate
    tqdm
    tritonclient
  ];

  passthru.optional-dependencies = {
    all = [ pycocotools ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # Test requires network access and API key
    "test_export_workflow_general"
    "test_validate_invalid_id"
    "test_validate_invalid_hex_id"
  ];

  disabledTestPaths = [
    # Tests require network access and API key
    "tests/test_app.py"
    "tests/test_data_upload.py"
    "tests/test_eval.py"
    "tests/test_model_predict.py"
    "tests/test_model_train.py"
    "tests/test_search.py"
    "tests/workflow/test_create_delete.py"
    "tests/workflow/test_predict.py"
    "tests/test_rag.py"
    "clarifai/models/model_serving/repo_build/static_files/base_test.py"
  ];

  pythonImportsCheck = [ "clarifai" ];

  meta = with lib; {
    description = "Clarifai Python Utilities";
    homepage = "https://github.com/Clarifai/clarifai-python";
    changelog = "https://github.com/Clarifai/clarifai-python/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
    mainProgram = "clarifai";
  };
}
