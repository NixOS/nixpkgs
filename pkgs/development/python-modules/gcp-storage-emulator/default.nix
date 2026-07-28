{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  fs,
  google-cloud-storage,
  google-crc32c,
  pytestCheckHook,
  pytest-cov-stub,
  requests,
}:

buildPythonPackage rec {
  pname = "gcp-storage-emulator";
  version = "2024.08.03";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oittaa";
    repo = "gcp-storage-emulator";
    tag = "v${version}";
    hash = "sha256-Lp9Wvod0wSE2+cnvLXguhagT30ax9TivyR8gC/kB7w0=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    fs
    google-crc32c
  ];

  nativeCheckInputs = [
    google-cloud-storage
    pytest-cov-stub
    pytestCheckHook
    requests
  ];

  disabledTests = [
    "test_invalid_crc32c_hash" # AssertionError
  ];

  pythonImportsCheck = [
    "gcp_storage_emulator"
  ];

  meta = {
    description = "Local emulator for Google Cloud Storage";
    homepage = "https://github.com/oittaa/gcp-storage-emulator";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    mainProgram = "gcp-storage-emulator";
  };
}
