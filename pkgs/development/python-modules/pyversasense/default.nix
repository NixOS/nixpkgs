{
  lib,
  aiohttp,
  asynctest,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyversasense";
  version = "0.0.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "imstevenxyz";
    repo = "pyversasense";
    rev = "v${version}";
    sha256 = "vTaDEwImWDMInwti0Jj+j+RFEtXOOKtiH5wOMD6ZmJk=";
  };

  propagatedBuildInputs = [ aiohttp ];

  doCheck = false; # asynctest unsupported on 3.11+

  nativeCheckInputs = [
    asynctest
    pytest-asyncio
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests/test.py" ];

  disabledTests = [
    # Tests are not properly mocking network requests
    "test_device_mac"
    "test_peripheral_id"
    "test_peripheral_measurements"
    "test_samples"
  ];

  pythonImportsCheck = [ "pyversasense" ];

  meta = {
    description = "Python library to communicate with the VersaSense API";
    homepage = "https://github.com/imstevenxyz/pyversasense";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
