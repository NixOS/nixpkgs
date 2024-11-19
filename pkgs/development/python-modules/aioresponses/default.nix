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
  version = "0.7.6";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-95XZ29otYXdIQOfjL1Nm9FdS0a3Bt0yTYq/QFylsfuE=";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/pnuckowski/aioresponses/pull/262
      name = "aiohttp-3.11.0-compat.patch";
      url = "https://github.com/pnuckowski/aioresponses/commit/e909123c5a70180a54443899d26b44ada511cd39.patch";
      hash = "sha256-i/2rPtX64buVrVDSdB06NMOJCTdgENsxZDyphXWRwJI=";
    })
  ];

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
    description = "Helper to mock/fake web requests in python aiohttp package";
    homepage = "https://github.com/pnuckowski/aioresponses";
    license = lib.licenses.mit;
  };
}
