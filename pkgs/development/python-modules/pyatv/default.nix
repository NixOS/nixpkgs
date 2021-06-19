{ lib
, buildPythonPackage
, aiohttp
, aiozeroconf
, cryptography
, deepdiff
, fetchFromGitHub
, netifaces
, protobuf
, pytest-aiohttp
, pytest-asyncio
, pytest-runner
, pytest-timeout
, pytestCheckHook
, srptools
, zeroconf
}:

buildPythonPackage rec {
  pname = "pyatv";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "postlund";
    repo = pname;
    rev = "v${version}";
    sha256 = "1slr6l0gw0mf1zhp40bjf5bib45arw1cy4fqkg0gvdk1hx79828m";
  };

  nativeBuildInputs = [ pytest-runner];

  propagatedBuildInputs = [
    aiohttp
    aiozeroconf
    cryptography
    netifaces
    protobuf
    srptools
    zeroconf
  ];

  checkInputs = [
    deepdiff
    pytest-aiohttp
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "pyatv" ];

  meta = with lib; {
    description = "Python client library for the Apple TV";
    homepage = "https://github.com/postlund/pyatv";
    license = licenses.mit;
    maintainers = with maintainers; [ elseym ];
  };
}
