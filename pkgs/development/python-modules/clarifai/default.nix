{ lib
, buildPythonPackage
, clarifai-grpc
, fetchFromGitHub
, inquirerpy
, llama-index-core
, numpy
, opencv4
, pandas
, pillow
, pycocotools
, pypdf
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, pyyaml
, rich
, schema
, setuptools
, tabulate
, tqdm
, tritonclient
}:

buildPythonPackage rec {
  pname = "clarifai";
  version = "10.2.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Clarifai";
    repo = "clarifai-python";
    rev = "refs/tags/${version}";
    hash = "sha256-jI85xMApeEd0Hl6h4Am5qxWoSSTWHsmb7FxUjJPmBQM=";
  };

  pythonRelaxDeps = [
    "clarifai-grpc"
  ];

  pythonRemoveDeps = [
    "opencv-python"
  ];

  build-system = [
    pythonRelaxDepsHook
    setuptools
  ];

  dependencies = [
    clarifai-grpc
    inquirerpy
    llama-index-core
    numpy
    opencv4
    pandas
    pillow
    pypdf
    pyyaml
    rich
    schema
    tabulate
    tqdm
    tritonclient
  ];

  passthru.optional-dependencies = {
    all = [
      pycocotools
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # Test requires network access and API key
    "test_export_workflow_general"
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

  pythonImportsCheck = [
    "clarifai"
  ];

  meta = with lib; {
    description = "Clarifai Python Utilities";
    homepage = "https://github.com/Clarifai/clarifai-python";
    changelog = "https://github.com/Clarifai/clarifai-python/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
    mainProgram = "clarifai";
  };
}
