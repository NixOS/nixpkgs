{ lib
, aiohttp
, buildPythonPackage
, ddt
, fetchPypi
, pbr
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "aioresponses";
  version = "0.7.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eUs+BIN6aD/SwMCZvfd/jX7N0oS8LBUgMANRi/XLjag=";
  };

  nativeBuildInputs = [
    pbr
  ];

  propagatedBuildInputs = [
    aiohttp
    setuptools
  ];

  nativeCheckInputs = [
    ddt
    pytestCheckHook
  ];

  disabledTests = [
    # Skip a test which makes requests to httpbin.org
    "test_address_as_instance_of_url_combined_with_pass_through"
    "test_pass_through_with_origin_params"
  ];

  pythonImportsCheck = [
    "aioresponses"
  ];

  meta = with lib; {
    description = "A helper to mock/fake web requests in python aiohttp package";
    homepage = "https://github.com/pnuckowski/aioresponses";
    license = licenses.mit;
    maintainers = with maintainers; [ rvl ];
  };
}
