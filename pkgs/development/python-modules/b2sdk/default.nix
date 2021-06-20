{ lib
, arrow
, buildPythonPackage
, fetchPypi
, importlib-metadata
, isPy27
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
  version = "1.7.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8X5XLh9SxZI1P7/2ZjOy8ipcEzTcriJfGI7KlMXncv4=";
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
  ];

  pythonImportsCheck = [ "b2sdk" ];

  meta = with lib; {
    description = "Client library and utilities for access to B2 Cloud Storage (backblaze)";
    homepage = "https://github.com/Backblaze/b2-sdk-python";
    license = licenses.mit;
  };
}
