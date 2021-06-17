{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytest-error-for-skips
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "nettigo-air-monitor";
  version = "0.2.6";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = pname;
    rev = version;
    sha256 = "0zs14g02m1ahyrhl2ihk74fp390g4672r1jjiaawmkxrvib07dvp";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    aioresponses
    pytest-asyncio
    pytest-error-for-skips
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
    substituteInPlace setup.cfg \
      --replace "--cov --cov-report term-missing " ""
  '';

  pythonImportsCheck = [ "nettigo_air_monitor" ];

  meta = with lib; {
    description = "Python module to get air quality data from Nettigo Air Monitor devices";
    homepage = "https://github.com/bieniu/nettigo-air-monitor";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
