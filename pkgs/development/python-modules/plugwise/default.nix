{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, crcmod
, defusedxml
, fetchFromGitHub
, jsonpickle
, munch
, mypy
, pyserial
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, python-dateutil
, pytz
, semver
}:

buildPythonPackage rec {
  pname = "plugwise";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = "python-plugwise";
    rev = "v${version}";
    sha256 = "1sv421aa6ip74ajxa5imnh188hyx9dq3vwkb6aifi14h2wpr9lh3";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    crcmod
    defusedxml
    munch
    pyserial
    python-dateutil
    pytz
    semver
  ];

  checkInputs = [
    jsonpickle
    mypy
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "plugwise" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Python module for Plugwise Smiles, Stretch and USB stick";
    longDescription = ''
      XKNX is an asynchronous Python library for reading and writing KNX/IP
      packets. It provides support for KNX/IP routing and tunneling devices.
    '';
    homepage = "https://github.com/plugwise/python-plugwise";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
