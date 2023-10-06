{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, glibcLocales
, importlib-metadata
, logfury
, pyfakefs
, pytestCheckHook
, pytest-lazy-fixture
, pytest-mock
, pythonOlder
, requests
, setuptools-scm
, tqdm
, typing-extensions
}:

buildPythonPackage rec {
  pname = "b2sdk";
  version = "1.24.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6zSjCt+J6530f1GMc/omP1zXKQKU1SDLLvslMWoqMcU=";
  };

  nativeBuildInputs = [
    setuptools-scm
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

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'setuptools_scm<6.0' 'setuptools_scm'
  '';

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
