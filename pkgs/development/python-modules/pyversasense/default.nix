{ lib
, aiohttp
, asynctest
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyversasense";
  version = "0.0.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "imstevenxyz";
    repo = pname;
    rev = "v${version}";
    sha256 = "vTaDEwImWDMInwti0Jj+j+RFEtXOOKtiH5wOMD6ZmJk=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  nativeCheckInputs = [
    asynctest
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests/test.py"
  ];

  disabledTests = [
    # Tests are not properly mocking network requests
    "test_device_mac"
    "test_peripheral_id"
    "test_peripheral_measurements"
    "test_samples"
  ];

  pythonImportsCheck = [
    "pyversasense"
  ];

  meta = with lib; {
    description = "Python library to communicate with the VersaSense API";
    homepage = "https://github.com/imstevenxyz/pyversasense";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
