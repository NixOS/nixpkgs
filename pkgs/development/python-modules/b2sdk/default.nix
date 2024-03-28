{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, glibcLocales
, importlib-metadata
, logfury
, pyfakefs
, pytestCheckHook
, pytest-lazy-fixture
, pytest-mock
, pythonOlder
, pythonRelaxDepsHook
, pdm-backend
, requests
, tqdm
, typing-extensions
}:

buildPythonPackage rec {
  pname = "b2sdk";
  version = "1.33.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Backblaze";
    repo = "b2-sdk-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-eMFgsjEb0DMTLqG+8IZru1dEAuKZW4dEszrznZxR+mc=";
  };

  nativeBuildInputs = [
    pdm-backend
    pythonRelaxDepsHook
  ];

  pythonRemoveDeps = [
    "setuptools"
  ];

  propagatedBuildInputs = [
    logfury
    requests
    tqdm
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ] ++ lib.optionals (pythonOlder "3.12") [
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-lazy-fixture
    pytest-mock
    pyfakefs
  ] ++ lib.optionals stdenv.isLinux [
    glibcLocales
  ];

  disabledTestPaths = [
    # requires aws s3 auth
    "test/integration/test_download.py"
    "test/integration/test_upload.py"
  ];

  disabledTests = [
    # Test requires an API key
    "test_raw_api"
    "test_files_headers"
    "test_large_file"
    "test_file_info_b2_attributes"
  ];

  pythonImportsCheck = [
    "b2sdk"
  ];

  meta = with lib; {
    description = "Client library and utilities for access to B2 Cloud Storage (backblaze)";
    homepage = "https://github.com/Backblaze/b2-sdk-python";
    changelog = "https://github.com/Backblaze/b2-sdk-python/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
