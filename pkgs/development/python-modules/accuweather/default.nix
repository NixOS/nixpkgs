{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestrunner
, aiohttp
, aioresponses
, pytestCheckHook
, pytestcov
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "accuweather";
  version = "0.1.0";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = pname;
    rev = version;
    sha256 = "0jp2x7fgg1shgr1fx296rni00lmjjmjgg141giljzizgd04dwgy3";
  };

  postPatch = ''
    # we don't have pytest-error-for-skips packaged
    substituteInPlace pytest.ini --replace "--error-for-skips" ""
  '';

  nativeBuildInputs = [ pytestrunner ];

  propagatedBuildInputs = [ aiohttp ];

  checkInputs = [
    aioresponses
    pytestCheckHook
    pytestcov
    pytest-asyncio
  ];

  meta = with lib; {
    description =
      "Python wrapper for getting weather data from AccuWeather servers.";
    homepage = "https://github.com/bieniu/accuweather";
    license = licenses.asl20;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
