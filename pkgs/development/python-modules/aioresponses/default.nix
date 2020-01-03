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
  version = "0.6.1";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fab9607d11a2e05050ef766006b8fdd9424e7122c2bd6f34a5376be4c728e242";
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
