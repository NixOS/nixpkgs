{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  azure-identity,
  azure-storage-blob,
  azure-storage-file-share,
  boto3,
  google-cloud-storage,
  huggingface-hub,
  requests,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "kserve-storage";
  version = "0.16.0";
  pyproject = true;

  src = fetchPypi {
    pname = "kserve_storage";
    inherit version;
    hash = "sha256-xgLnWegsPF18RLxwxt0dfnrZwsX7AK3b8AdT594Bac4=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "google-cloud-storage"
  ];
  dependencies = [
    azure-identity
    azure-storage-blob
    azure-storage-file-share
    boto3
    google-cloud-storage
    huggingface-hub
    requests
  ];

  pythonImportsCheck = [ "kserve_storage" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # RuntimeError: Failed to fetch model. No model found in file:///tmp.
    "test_local_path_with_out_dir_exist"
  ];

  meta = {
    description = "KServe Storage Handler. This module is responsible to download the models from the provided source";
    homepage = "https://pypi.org/project/kserve-storage";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
