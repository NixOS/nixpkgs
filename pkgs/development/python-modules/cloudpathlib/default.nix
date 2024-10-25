{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  flit-core,
  typing-extensions,
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
  version = "0.19.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "drivendataorg";
    repo = "cloudpathlib";
    rev = "refs/tags/v${version}";
    hash = "sha256-VjoQc9nzwcMh9kiqWXsJNE5X7e7/sVGId5jgFTLZQy4=";
  };

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
    psutil
    pydantic
    pytestCheckHook
    pytest-cases
    pytest-cov-stub
    pytest-xdist
    python-dotenv
    shortuuid
    tenacity
  ] ++ optional-dependencies.all;

  meta = with lib; {
    description = "Python pathlib-style classes for cloud storage services such as Amazon S3, Azure Blob Storage, and Google Cloud Storage";
    homepage = "https://github.com/drivendataorg/cloudpathlib";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
