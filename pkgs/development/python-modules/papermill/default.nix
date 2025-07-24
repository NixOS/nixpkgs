{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  ansicolors,
  click,
  entrypoints,
  nbclient,
  nbformat,
  pyyaml,
  requests,
  tenacity,
  tqdm,
  pythonAtLeast,
  aiohttp,

  # optional-dependencies
  azure-datalake-store,
  azure-identity,
  azure-storage-blob,
  gcsfs,
  pygithub,
  pyarrow,
  boto3,

  # tests
  ipykernel,
  moto,
  pytest-mock,
  pytestCheckHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "papermill";
  version = "2.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nteract";
    repo = "papermill";
    tag = version;
    hash = "sha256-NxC5+hRDdMCl/7ZIho5ml4hdENrgO+wzi87GRPeMv8Q=";
  };

  build-system = [ setuptools ];

  dependencies = [
    ansicolors
    click
    entrypoints
    nbclient
    nbformat
    pyyaml
    requests
    tenacity
    tqdm
  ]
  ++ lib.optionals (pythonAtLeast "3.12") [ aiohttp ];

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

  nativeCheckInputs = [
    ipykernel
    moto
    pytest-mock
    pytestCheckHook
    versionCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ optional-dependencies.azure
  ++ optional-dependencies.s3
  ++ optional-dependencies.gcs;
  versionCheckProgramArg = "--version";

  pythonImportsCheck = [ "papermill" ];

  # Using pytestFlagsArray to prevent disabling false positives
  pytestFlagsArray = [
    # AssertionError: 'error' != 'display_data'
    "--deselect=papermill/tests/test_execute.py::TestBrokenNotebook2::test"

    # AssertionError: '\x1b[31mSystemExit\x1b[39m\x1b[31m:\x1b[39m 1\n' != '\x1b[0;31mSystemExit\x1b[0m\x1b[0;31m:\x1b[0m 1\n'
    "--deselect=papermill/tests/test_execute.py::TestOutputFormatting::test_output_formatting"
  ];

  disabledTests = [
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

  meta = {
    description = "Parametrize and run Jupyter and interact with notebooks";
    homepage = "https://github.com/nteract/papermill";
    changelog = "https://papermill.readthedocs.io/en/latest/changelog.html";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    mainProgram = "papermill";
  };
}
