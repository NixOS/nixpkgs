{ aiohttp, buildPythonPackage, fetchFromGitHub, lib, pytest, pytestCheckHook
, pytestcov, pytestrunner, pytest-asyncio, python, pythonOlder }:

buildPythonPackage rec {
  pname = "accuweather";
  version = "0.0.11";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = pname;
    rev = version;
    sha256 = "1sgbw9yldf81phwx6pbvqg9sp767whxymyj0ca9pwx1r6ipr080h";
  };

  nativeBuildInputs = [ pytestrunner ];
  propagatedBuildInputs = [ aiohttp ];
  checkInputs = [ pytestCheckHook pytestcov pytest-asyncio ];

  meta = with lib; {
    description =
      "Python wrapper for getting weather data from AccuWeather servers.";
    homepage = "https://github.com/bieniu/accuweather";
    license = licenses.asl20;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
