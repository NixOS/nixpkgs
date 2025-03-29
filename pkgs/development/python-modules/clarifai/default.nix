{
  lib,
  buildPythonPackage,
  clarifai-grpc,
  clarifai-protocol,
  click,
  fetchFromGitHub,
  fsspec,
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
  version = "11.0.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Clarifai";
    repo = "clarifai-python";
    tag = version;
    hash = "sha256-JLZGVVrvGVUWr7WCTu2alVl+4GuYqLWP2dodgxYbmgc=";
  };

  pythonRelaxDeps = [
    "fsspec"
    "schema"
  ];

  build-system = [ setuptools ];

  dependencies = [
    clarifai-grpc
    clarifai-protocol
    click
    fsspec
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

  optional-dependencies = {
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
    "tests/cli/test_compute_orchestration.py"
    "tests/runners/test_anymodel.py"
    "tests/runners/test_download_checkpoints.py"
    "tests/runners/test_runners.py"
    "tests/runners/test_textmodel.py"
    "tests/runners/test_url_fetcher.py"
    "tests/test_app.py"
    "tests/test_data_upload.py"
    "tests/test_eval.py"
    "tests/test_model_predict.py"
    "tests/test_model_train.py"
    "tests/test_rag.py"
    "tests/test_search.py"
    "tests/workflow/test_create_delete.py"
    "tests/workflow/test_predict.py"
  ];

  pythonImportsCheck = [ "clarifai" ];

  meta = with lib; {
    description = "Clarifai Python Utilities";
    homepage = "https://github.com/Clarifai/clarifai-python";
    changelog = "https://github.com/Clarifai/clarifai-python/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
    mainProgram = "clarifai";
  };
}
