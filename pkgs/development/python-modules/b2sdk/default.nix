{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  glibcLocales,
  importlib-metadata,
  logfury,
  packaging,
  pdm-backend,
  pyfakefs,
  pytest-lazy-fixture,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  pythonRelaxDepsHook,
  requests,
  tqdm,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "b2sdk";
  version = "2.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Backblaze";
    repo = "b2-sdk-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-Duva6rFYtMAfMYb2Ze8k3jIX8Ld8u4zdl7WXDbS0o64=";
  };

  build-system = [ pdm-backend ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  pythonRemoveDeps = [ "setuptools" ];

  dependencies =
    [
      packaging
      logfury
      requests
    ]
    ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ]
    ++ lib.optionals (pythonOlder "3.12") [ typing-extensions ];

  nativeCheckInputs = [
    pyfakefs
    pytest-lazy-fixture
    pytest-mock
    pytestCheckHook
    tqdm
  ] ++ lib.optionals stdenv.isLinux [ glibcLocales ];

  disabledTestPaths = [
    # requires aws s3 auth
    "test/integration/test_download.py"
    "test/integration/test_upload.py"

    # Requires backblaze auth
    "test/integration/test_bucket.py"
  ];

  disabledTests = [
    # Test requires an API key
    "test_raw_api"
    "test_files_headers"
    "test_large_file"
    "test_file_info_b2_attributes"
  ];

  pythonImportsCheck = [ "b2sdk" ];

  meta = with lib; {
    description = "Client library and utilities for access to B2 Cloud Storage (backblaze)";
    homepage = "https://github.com/Backblaze/b2-sdk-python";
    changelog = "https://github.com/Backblaze/b2-sdk-python/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
