{ lib
, aiohttp
, asynctest
, buildPythonPackage
, ddt
, fetchPypi
, pbr
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioresponses";
  version = "0.7.3";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-LGTtVxDujLTpWMVpGE2tEvTJzVk5E1yzj4jGqCYczrM=";
  };

  nativeBuildInputs = [
    pbr
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    asynctest
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

  meta = {
    description = "A helper to mock/fake web requests in python aiohttp package";
    homepage = "https://github.com/pnuckowski/aioresponses";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rvl ];
  };
}
