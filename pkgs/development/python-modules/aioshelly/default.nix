{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, netifaces
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioshelly";
  version = "2.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-BUKuZza9Jer334LUmU5zmfjg1ISuxg7HETEbUMB80KY=";
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
