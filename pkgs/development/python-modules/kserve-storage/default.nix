{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  aiohttp,
  azure-identity,
  azure-storage-blob,
  azure-storage-file-share,
  boto3,
  certifi,
  cryptography,
  dulwich,
  google-cloud-storage,
  hf-xet,
  huggingface-hub,
  pyasn1,
  pyjwt,
  requests,

  # tests
  jwcrypto,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "kserve-storage";
  version = "0.20.0";
  pyproject = true;

  src = fetchPypi {
    pname = "kserve_storage";
    inherit (finalAttrs) version;
    hash = "sha256-8tBFGx++hMQkZfptV0EuFePZrlN1Tn5TlefzGop9aU0=";
  };

  pythonRelaxDeps = [ "google-cloud-storage" ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    azure-identity
    azure-storage-blob
    azure-storage-file-share
    boto3
    certifi
    cryptography
    dulwich
    google-cloud-storage
    hf-xet
    huggingface-hub
    pyasn1
    pyjwt
    requests
  ];

  pythonImportsCheck = [ "kserve_storage" ];

  nativeCheckInputs = [
    jwcrypto
    pytestCheckHook
  ];

  disabledTests = [
    # RuntimeError: Failed to fetch model. No model found in file:///tmp.
    "test_local_path_with_out_dir_exist"
  ];

  meta = {
    description = "KServe Storage Handler. This module is responsible to download the models from the provided source";
    homepage = "https://github.com/kserve/kserve/tree/master/python/storage";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
