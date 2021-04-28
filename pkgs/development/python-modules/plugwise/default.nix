{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, async-timeout
, crcmod
, defusedxml
, pyserial
, pytz
, python-dateutil
, semver
, jsonpickle
, mypy
, pytest-aiohttp
, pytest-asyncio
, pytest-cov
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "plugwise";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = "python-plugwise";
    rev = version;
    sha256 = "sha256-MZ4R55vGUyWmR0Md83eNerzsgtYMch1vfQ3sqbm12bM=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    crcmod
    defusedxml
    pyserial
    pytz
    python-dateutil
    semver
  ];

  checkInputs = [
    jsonpickle
    mypy
    pytest-aiohttp
    pytest-asyncio
    pytest-cov
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
