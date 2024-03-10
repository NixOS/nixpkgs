{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
, setuptools
}:

buildPythonPackage rec {
  pname = "python-fsutil";
  version = "0.13.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fabiocaccamo";
    repo = "python-fsutil";
    rev = "refs/tags/${version}";
    hash = "sha256-yY8hhw6uNKqrcj0geoQeGN/JCDJVja7pCPUHwoViL64=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests/test.py"
  ];

  disabledTests = [
    # Tests require network access
    "test_download_file"
    "test_read_file_from_url"
  ];

  pythonImportsCheck = [
    "fsutil"
  ];

  meta = with lib; {
    description = "Module with file-system utilities";
    homepage = "https://github.com/fabiocaccamo/python-fsutil";
    changelog = "https://github.com/fabiocaccamo/python-fsutil/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
