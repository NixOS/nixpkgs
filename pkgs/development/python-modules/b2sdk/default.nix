{ lib
, arrow
, buildPythonPackage
, fetchPypi
, importlib-metadata
, logfury
, pytestCheckHook
, pytest-lazy-fixture
, pytest-mock
, pythonOlder
, requests
, setuptools-scm
, tqdm
}:

buildPythonPackage rec {
  pname = "b2sdk";
  version = "1.14.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fYOeyhKm9mRT61NcQVaXFKeRC8AS9lfIZMO/s6iFaeg=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    arrow
    logfury
    requests
    tqdm
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [
    pytestCheckHook
    pytest-lazy-fixture
    pytest-mock
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'setuptools_scm<6.0' 'setuptools_scm'
    substituteInPlace requirements.txt \
      --replace 'arrow>=0.8.0,<1.0.0' 'arrow'
  '';

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
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
