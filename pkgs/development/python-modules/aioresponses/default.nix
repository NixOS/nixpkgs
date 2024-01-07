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
  version = "0.7.4";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-m4wQizY1TARjO60Op1K1XZVqdgL+PjI0uTn8RK+W8dg=";
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

  meta = {
    description = "A helper to mock/fake web requests in python aiohttp package";
    homepage = "https://github.com/pnuckowski/aioresponses";
    license = lib.licenses.mit;
  };
}
