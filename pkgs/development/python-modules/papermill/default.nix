{ lib
, azure-datalake-store
, azure-identity
, azure-storage-blob
, boto3
, buildPythonPackage
, click
, entrypoints
, fetchFromGitHub
, gcsfs
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
    pytestCheckHook
    pytest-mock
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # The test suite depends on cloud resources azure/aws
  doCheck = false;

  pythonImportsCheck = [
    "papermill"
  ];

  meta = with lib; {
    description = "Parametrize and run Jupyter and interact with notebooks";
    homepage = "https://github.com/nteract/papermill";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
