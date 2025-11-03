{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  pythonOlder,
  typing-extensions,

  # optional-dependencies
  azure-storage-blob,
  azure-storage-file-datalake,
  google-cloud-storage,
  boto3,

  # tests
  azure-identity,
  psutil,
  pydantic,
  pytestCheckHook,
  pytest-cases,
  pytest-cov-stub,
  pytest-xdist,
  python-dotenv,
  shortuuid,
  tenacity,
}:

buildPythonPackage rec {
  pname = "cloudpathlib";
  version = "0.23.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "drivendataorg";
    repo = "cloudpathlib";
    tag = "v${version}";
    hash = "sha256-lRZYWGX3Yqs1GTIL3ugOiu+K9RF6vJdbKP/SZAStHLc=";
  };

  postPatch =
    # missing pytest-reportlog test dependency
    ''
      substituteInPlace pyproject.toml \
        --replace-fail "--report-log reportlog.jsonl" ""
    '';

  build-system = [ flit-core ];

  dependencies = lib.optionals (pythonOlder "3.11") [
    typing-extensions
  ];

  optional-dependencies = {
    all = optional-dependencies.azure ++ optional-dependencies.gs ++ optional-dependencies.s3;
    azure = [
      azure-storage-blob
      azure-storage-file-datalake
    ];
    gs = [ google-cloud-storage ];
    s3 = [ boto3 ];
  };

  pythonImportsCheck = [ "cloudpathlib" ];

  nativeCheckInputs = [
    azure-identity
    psutil
    pydantic
    pytestCheckHook
    pytest-cases
    pytest-cov-stub
    pytest-xdist
    python-dotenv
    shortuuid
    tenacity
  ]
  ++ optional-dependencies.all;

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Python pathlib-style classes for cloud storage services such as Amazon S3, Azure Blob Storage, and Google Cloud Storage";
    homepage = "https://github.com/drivendataorg/cloudpathlib";
    changelog = "https://github.com/drivendataorg/cloudpathlib/blob/${src.tag}/HISTORY.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
