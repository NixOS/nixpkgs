{ lib
<<<<<<< HEAD
, stdenv
, buildPythonPackage
, fetchPypi
, glibcLocales
=======
, arrow
, buildPythonPackage
, fetchPypi
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
, typing-extensions
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "b2sdk";
<<<<<<< HEAD
  version = "1.24.0";
=======
  version = "1.19.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-6zSjCt+J6530f1GMc/omP1zXKQKU1SDLLvslMWoqMcU=";
=======
    hash = "sha256-aJpSt+dXjw4S33dBiMkaR6wxzwLru+jseuPKFj2R36Y=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
<<<<<<< HEAD
=======
    arrow
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    logfury
    requests
    tqdm
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
<<<<<<< HEAD
  ] ++ lib.optionals (pythonOlder "3.12") [
    typing-extensions
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-lazy-fixture
    pytest-mock
    pyfakefs
<<<<<<< HEAD
  ] ++ lib.optionals stdenv.isLinux [
    glibcLocales
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'setuptools_scm<6.0' 'setuptools_scm'
<<<<<<< HEAD
=======
    substituteInPlace requirements.txt \
      --replace 'arrow>=0.8.0,<1.0.0' 'arrow'
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/Backblaze/b2-sdk-python/blob/v${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
