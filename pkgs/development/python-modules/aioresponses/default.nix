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
  version = "0.6.3";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06w15iyr07s861hkzqfdclzxkpvgg83sx8f235mz8k2490hnyqvv";
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
