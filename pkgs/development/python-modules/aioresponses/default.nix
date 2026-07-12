{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  pbr,
  setuptools,

  # dependencies
  aiohttp,

  # tests
  ddt,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aioresponses";
  version = "0.7.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Hc+iiTj8AG8Eapg4OnwHrBgL56SSwe1Vf1zXsIBTV9M=";
  };

  patches = [
    # https://github.com/pnuckowski/aioresponses/issues/289
    # https://github.com/pnuckowski/aioresponses/pull/292
    ./aiohttp-3.14-compat.patch
  ];

  build-system = [
    pbr
    setuptools
  ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [ "aioresponses" ];

  nativeCheckInputs = [
    ddt
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Skip tests which make requests to httpbin.org
    "test_address_as_instance_of_url_combined_with_pass_through"
    "test_pass_through_with_origin_params"
    "test_pass_through_unmatched_requests"
  ];

  meta = {
    changelog = "https://github.com/pnuckowski/aioresponses/releases/tag/${version}";
    description = "Helper to mock/fake web requests in python aiohttp package";
    homepage = "https://github.com/pnuckowski/aioresponses";
    license = lib.licenses.mit;
  };
}
