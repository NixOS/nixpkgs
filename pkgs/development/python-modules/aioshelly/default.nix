{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, netifaces
}:

buildPythonPackage rec {
  pname = "aioshelly";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = version;
    sha256 = "sha256-tHGay/esk97oJJhBUD4QOi5IkUBrrQe5koVVdR5NQGw=";
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
