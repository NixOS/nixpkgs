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
  version = "0.17.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = pname;
    repo = "python-plugwise";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-PZoxI7s3LTb60oXFfsOi5mCaLOKzq6ed2yFKap0Q1Ng=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "aiohttp==3.8.0" "aiohttp>=3.8.0"
  '';

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
