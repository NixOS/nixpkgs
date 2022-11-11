{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, orjson
, pytest-asyncio
, pytest-error-for-skips
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "accuweather";
  version = "0.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = pname;
    rev = version;
    hash = "sha256-NnDpSOEIqPuPLIr0Ty6yjrs9WRKyhykcdyiRPB/cHEw=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
    substituteInPlace setup.cfg \
      --replace "--cov --cov-report term-missing" ""
  '';

  propagatedBuildInputs = [
    aiohttp
    orjson
  ];

  checkInputs = [
    aioresponses
    pytest-asyncio
    pytest-error-for-skips
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "accuweather"
  ];

  meta = with lib; {
    description = "Python wrapper for getting weather data from AccuWeather servers";
    homepage = "https://github.com/bieniu/accuweather";
    license = licenses.asl20;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
