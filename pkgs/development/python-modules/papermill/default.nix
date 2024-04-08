{ lib
, stdenv
, azure-datalake-store
, azure-identity
, azure-storage-blob
, boto3
, buildPythonPackage
, click
, entrypoints
, fetchFromGitHub
, gcsfs
, ipykernel
, moto
, nbclient
, nbformat
, pyarrow
, pygithub
, pytest-mock
, pytestCheckHook
, pythonOlder
, pyyaml
, requests
, setuptools
, tenacity
, tqdm
}:

buildPythonPackage rec {
  pname = "papermill";
  version = "2.5.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nteract";
    repo = "papermill";
    rev = "refs/tags/${version}";
    hash = "sha256-x6f5hhTdOPDVFiBvRhfrXq1wd5keYiuUshXnT0IkjX0=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    click
    pyyaml
    nbformat
    nbclient
    tqdm
    requests
    entrypoints
    tenacity
  ];

  passthru.optional-dependencies = {
    azure = [
      azure-datalake-store
      azure-identity
      azure-storage-blob
    ];
    gcs = [
      gcsfs
    ];
    github = [
      pygithub
    ];
    hdfs = [
      pyarrow
    ];
    s3 = [
      boto3
    ];
  };

  nativeCheckInputs = [
    ipykernel
    moto
    pytest-mock
    pytestCheckHook
  ] ++ passthru.optional-dependencies.azure
    ++ passthru.optional-dependencies.s3
    ++ passthru.optional-dependencies.gcs;

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [
    "papermill"
  ];

  pytestFlagsArray = [
    "-W" "ignore::pytest.PytestRemovedIn8Warning"
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    # might fail due to the sandbox
    "test_end2end_autosave_slow_notebook"
  ];

  disabledTestPaths = [
    # ImportError: cannot import name 'mock_s3' from 'moto'
    "papermill/tests/test_s3.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Parametrize and run Jupyter and interact with notebooks";
    homepage = "https://github.com/nteract/papermill";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    mainProgram = "papermill";
  };
}
