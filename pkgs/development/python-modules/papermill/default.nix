{ lib
, ansiwrap
, azure-datalake-store
, azure-storage-blob
, boto3
, buildPythonPackage
, click
, entrypoints
, fetchPypi
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
, tenacity
, tqdm
}:

buildPythonPackage rec {
  pname = "papermill";
  version = "2.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-b4+KmwazlnfyB8CRAMjThrz1kvDLvdqfD1DoFEVpdic=";
  };

  propagatedBuildInputs = [
    ansiwrap
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
    maintainers = with maintainers; [ costrouc ];
  };
}
