{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  flit-core,
  typing-extensions,
  azure-identity,
  azure-storage-blob,
  azure-storage-file-datalake,
  google-cloud-storage,
  boto3,
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
  version = "0.22.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "drivendataorg";
    repo = "cloudpathlib";
    tag = "v${version}";
    hash = "sha256-IeNYfYDvCALvK0CV4J6434E3lSz+/JvolQzQXZ8NizQ=";
  };

  postPatch = ''
    # missing pytest-reportlog test dependency
    substituteInPlace pyproject.toml \
      --replace-fail "--report-log reportlog.jsonl" ""
  '';

  build-system = [ flit-core ];

  dependencies = lib.optional (pythonOlder "3.11") typing-extensions;

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

  meta = with lib; {
    description = "Python pathlib-style classes for cloud storage services such as Amazon S3, Azure Blob Storage, and Google Cloud Storage";
    homepage = "https://github.com/drivendataorg/cloudpathlib";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
