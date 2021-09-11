{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, netifaces
}:

buildPythonPackage rec {
  pname = "aioshelly";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = version;
    sha256 = "sha256-6CN2bY/dxOqCvL7a8BpVUOu5WL1WKMs9vK5q27Tvaqc=";
  };

  propagatedBuildInputs = [
    aiohttp
    netifaces
  ];

  # Project has no test
  doCheck = false;
  pythonImportsCheck = [ "aioshelly" ];

  meta = with lib; {
    description = "Python library to control Shelly";
    homepage = "https://github.com/home-assistant-libs/aioshelly";
    changelog = "https://github.com/home-assistant-libs/aioshelly/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
