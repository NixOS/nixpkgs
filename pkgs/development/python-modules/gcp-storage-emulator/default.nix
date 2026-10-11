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
  version = "2026.07.19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oittaa";
    repo = "gcp-storage-emulator";
    tag = "v${version}";
    hash = "sha256-l9zeDcWXr5fB/aIDaOV6wEMmXnOtbydnNkqeGo1b8oA=";
  };

  # upstream only sets the real version from GITHUB_REF when its CI builds a tag
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"0.0.0.dev0"' '"${version}"'
  '';

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
