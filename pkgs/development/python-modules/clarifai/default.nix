{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, clarifai-grpc
, numpy
, opencv4
, pillow
, pyyaml
, rich
, schema
, tqdm
, tritonclient
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "clarifai";
  version = "9.11.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Clarifai";
    repo = "clarifai-python";
    rev = "refs/tags/${version}";
    hash = "sha256-4m4h2TbiZPvcpZn8h0z+GN+9w3Udik2NVAtFSF4gFgQ=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    clarifai-grpc
    numpy
    tqdm
    opencv4
    tritonclient
    rich
    schema
    pillow
    pyyaml
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
