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
  pname = "accuweather";
  version = "0.1.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = pname;
    rev = version;
    sha256 = "sha256-fjOwa13hxY8/gCM6TCAFWVmEY1oZyqKyc6o3OSsxHpY=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
    substituteInPlace pytest.ini \
      --replace "--cov --cov-report term-missing" ""
  '';

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    aioresponses
    pytest-asyncio
    pytest-error-for-skips
    pytestCheckHook
  ];

  pythonImportsCheck = [ "accuweather" ];

  meta = with lib; {
    description = "Python wrapper for getting weather data from AccuWeather servers";
    homepage = "https://github.com/bieniu/accuweather";
    license = licenses.asl20;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
