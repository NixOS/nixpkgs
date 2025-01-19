{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch2,
  pythonOlder,

  # build-system
  pbr,
  setuptools,

  # dependencies
  aiohttp,

  # tests
  ddt,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aioresponses";
  version = "0.7.7";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZikvHVyUo8uYTzM22AZEYEKtsXNH0wifLTli3W5bpVo=";
  };

  nativeBuildInputs = [
    pbr
    setuptools
  ];

  propagatedBuildInputs = [ aiohttp ];

  pythonImportsCheck = [ "aioresponses" ];

  nativeCheckInputs = [
    ddt
    pytestCheckHook
  ];

  disabledTests = [
    # Skip tests which make requests to httpbin.org
    "test_address_as_instance_of_url_combined_with_pass_through"
    "test_pass_through_with_origin_params"
    "test_pass_through_unmatched_requests"
  ];

  meta = {
    description = "Helper to mock/fake web requests in python aiohttp package";
    homepage = "https://github.com/pnuckowski/aioresponses";
    license = lib.licenses.mit;
  };
}
