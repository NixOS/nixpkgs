{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  flake8,
  fs,
  google-cloud-storage,
  google-crc32c,
  pytest,
  pytestCheckHook,
  pytest-cov,
  requests,
}:

buildPythonPackage rec {
  pname = "gcp-storage-emulator";
  version = "2024.08.03";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oittaa";
    repo = "gcp-storage-emulator";
    rev = "v${version}";
    hash = "sha256-Lp9Wvod0wSE2+cnvLXguhagT30ax9TivyR8gC/kB7w0=";
  };

  build-system = [
    setuptools
    wheel
  ];

  nativeCheckInputs = [
    flake8
    fs
    google-cloud-storage
    google-crc32c
    pytest
    pytestCheckHook
    pytest-cov
    requests
  ];

  pythonImportsCheck = [
    "gcp_storage_emulator"
  ];

  meta = {
    description = "Local emulator for Google Cloud Storage";
    homepage = "https://github.com/oittaa/gcp-storage-emulator";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
