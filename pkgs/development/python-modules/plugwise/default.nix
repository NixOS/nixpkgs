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
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = pname;
    repo = "python-plugwise";
    rev = version;
    sha256 = "1gviyy31l1j8z0if2id3m13r43kw4mcgd8921813yfhmf174piq4";
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
