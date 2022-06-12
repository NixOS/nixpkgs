{ lib
, aiohttp
, buildPythonPackage
, faker
, fetchFromGitHub
, pytest-aiohttp
, pytest-mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiolookin";
  version = "0.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ANMalko";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xFxkhKM/lX/kSg709wID7HlkfNKDlOcL3STUZOrHZJ8=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    faker
    pytest-aiohttp
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = [
    # Not all tests are ready yet
    "test_successful"
  ];

  pythonImportsCheck = [
    "aiolookin"
  ];

  meta = with lib; {
    description = "Python client for interacting with LOOKin devices";
    homepage = "https://github.com/ANMalko/aiolookin";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
