{
  lib,
  buildPythonPackage,
  fetchPypi,
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
  version = "0.7.6";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-95XZ29otYXdIQOfjL1Nm9FdS0a3Bt0yTYq/QFylsfuE=";
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
    # Skip a test which makes requests to httpbin.org
    "test_address_as_instance_of_url_combined_with_pass_through"
    "test_pass_through_with_origin_params"
  ];

  meta = {
    description = "A helper to mock/fake web requests in python aiohttp package";
    homepage = "https://github.com/pnuckowski/aioresponses";
    license = lib.licenses.mit;
  };
}
