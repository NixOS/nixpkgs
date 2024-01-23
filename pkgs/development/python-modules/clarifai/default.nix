{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pythonRelaxDepsHook
, setuptools
, clarifai-grpc
, llama-index
, numpy
, opencv4
, pandas
, pillow
, pypdf
, pyyaml
, rich
, schema
, tqdm
, tritonclient
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "clarifai";
  version = "10.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Clarifai";
    repo = "clarifai-python";
    rev = "refs/tags/${version}";
    hash = "sha256-7y/PoQ1zRdbnNKQii6JUouXBuvgNSZm222RkNTAN+Y8=";
  };

  nativeBuildInputs = [
    setuptools
    pythonRelaxDepsHook
  ];

  pythonRemoveDeps = [
    "opencv-python"
  ];

  propagatedBuildInputs = [
    clarifai-grpc
    pandas
    numpy
    tqdm
    opencv4
    tritonclient
    rich
    pyyaml
    schema
    pillow
    llama-index
    pypdf
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # require network access and API key
    "test_export_workflow_general"
  ];

  disabledTestPaths = [
    # require network access and API key
    "tests/test_app.py"
    "tests/test_data_upload.py"
    "tests/test_model_predict.py"
    "tests/test_model_train.py"
    "tests/test_search.py"
    "tests/workflow/test_create_delete.py"
    "tests/workflow/test_predict.py"
  ];

  pythonImportsCheck = [ "clarifai" ];

  meta = with lib; {
    description = "Clarifai Python Utilities";
    homepage = "https://github.com/Clarifai/clarifai-python";
    changelog = "https://github.com/Clarifai/clarifai-python/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
  };
}
