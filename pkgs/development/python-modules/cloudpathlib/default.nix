{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, flit-core
, importlib-metadata
, typing-extensions
, cloudpathlib
, azure-storage-blob
, google-cloud-storage
, boto3
, psutil
, pydantic
, pytestCheckHook
, pytest-cases
, pytest-cov
, pytest-xdist
, python-dotenv
, shortuuid
}:

buildPythonPackage rec {
  pname = "cloudpathlib";
  version = "0.17.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "drivendataorg";
    repo = "cloudpathlib";
    rev = "refs/tags/v${version}";
    hash = "sha256-rj8v4EUMPdB5zmbP4VQli2H6GjDor3BHaA95GwoKS5E=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    importlib-metadata
    typing-extensions
  ];

  passthru.optional-dependencies = {
    all = [
      cloudpathlib
    ];
    azure = [
      azure-storage-blob
    ];
    gs = [
      google-cloud-storage
    ];
    s3 = [
      boto3
    ];
  };

  pythonImportsCheck = [ "cloudpathlib" ];

  nativeCheckInputs = [
    azure-storage-blob
    boto3
    google-cloud-storage
    psutil
    pydantic
    pytestCheckHook
    pytest-cases
    pytest-cov
    pytest-xdist
    python-dotenv
    shortuuid
  ];

  meta = with lib; {
    description = "Python pathlib-style classes for cloud storage services such as Amazon S3, Azure Blob Storage, and Google Cloud Storage";
    homepage = "https://github.com/drivendataorg/cloudpathlib";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
