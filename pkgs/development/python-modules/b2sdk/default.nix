{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  glibcLocales,
  importlib-metadata,
  logfury,
  annotated-types,
  packaging,
  pdm-backend,
  pyfakefs,
  pytest-lazy-fixtures,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  requests,
  tqdm,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "b2sdk";
  version = "2.7.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Backblaze";
    repo = "b2-sdk-python";
    tag = "v${version}";
    hash = "sha256-QY2/uWCnIlOHo5wTLxu2Pvh2oNPWRcyDL5TpnZHob7I=";
  };

  build-system = [ pdm-backend ];

  dependencies =
    [
      annotated-types
      packaging
      logfury
      requests
    ]
    ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ]
    ++ lib.optionals (pythonOlder "3.12") [ typing-extensions ];

  nativeCheckInputs = [
    pytest-lazy-fixtures
    pytest-mock
    pytestCheckHook
    tqdm
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ glibcLocales ];

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
    "test_sync_folder"
  ];

  pythonImportsCheck = [ "b2sdk" ];

  meta = with lib; {
    description = "Client library and utilities for access to B2 Cloud Storage (backblaze)";
    homepage = "https://github.com/Backblaze/b2-sdk-python";
    changelog = "https://github.com/Backblaze/b2-sdk-python/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ pmw ];
  };
}
