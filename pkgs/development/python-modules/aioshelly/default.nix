{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, netifaces
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioshelly";
  version = "1.0.10";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = version;
    hash = "sha256-YHdHh7uC9QF+dj+SI2Y4rEkBq+gGalNBmuWFVgq7XOM=";
  };

  propagatedBuildInputs = [
    aiohttp
    netifaces
  ];

  # Project has no test
  doCheck = false;

  pythonImportsCheck = [
    "aioshelly"
  ];

  meta = with lib; {
    description = "Python library to control Shelly";
    homepage = "https://github.com/home-assistant-libs/aioshelly";
    changelog = "https://github.com/home-assistant-libs/aioshelly/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
