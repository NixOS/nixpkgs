{
  lib,
  stdenv,
  aiohttp,
  ansicolors,
  azure-datalake-store,
  azure-identity,
  azure-storage-blob,
  boto3,
  buildPythonPackage,
  click,
  entrypoints,
  fetchFromGitHub,
  gcsfs,
  ipykernel,
  moto,
  nbclient,
  nbformat,
  pyarrow,
  pygithub,
  pytest-mock,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  pyyaml,
  requests,
  setuptools,
  tenacity,
  tqdm,
}:

buildPythonPackage rec {
  pname = "papermill";
  version = "2.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nteract";
    repo = "papermill";
    rev = "refs/tags/${version}";
    hash = "sha256-NxC5+hRDdMCl/7ZIho5ml4hdENrgO+wzi87GRPeMv8Q=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    pyyaml
    nbformat
    nbclient
    tqdm
    requests
    entrypoints
    tenacity
    ansicolors
  ] ++ lib.optionals (pythonAtLeast "3.12") [ aiohttp ];

  optional-dependencies = {
    azure = [
      azure-datalake-store
      azure-identity
      azure-storage-blob
    ];
    gcs = [ gcsfs ];
    github = [ pygithub ];
    hdfs = [ pyarrow ];
    s3 = [ boto3 ];
  };

  nativeCheckInputs =
    [
      ipykernel
      moto
      pytest-mock
      pytestCheckHook
    ]
    ++ optional-dependencies.azure
    ++ optional-dependencies.s3
    ++ optional-dependencies.gcs;

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "papermill" ];

  disabledTests =
    [
      # pytest 8 compat
      "test_read_with_valid_file_extension"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
    maintainers = [ ];
    mainProgram = "papermill";
  };
}
