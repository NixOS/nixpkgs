{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pbr
, aiohttp
, ddt
, asynctest
, pytest
}:

buildPythonPackage rec {
  pname = "aioresponses";
  version = "0.6.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ii1jiwb8qa2y8cqa1zqn7mjax9l8bpf16k4clv616mxw1l0bvs6";
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
    pytest
  ];

  # Skip a test which makes requests to httpbin.org
  checkPhase = ''
    pytest -k "not test_address_as_instance_of_url_combined_with_pass_through"
  '';

  meta = {
    description = "A helper to mock/fake web requests in python aiohttp package";
    homepage = https://github.com/pnuckowski/aioresponses;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rvl ];
  };
}
