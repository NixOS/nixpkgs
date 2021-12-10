{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
}:

buildPythonPackage rec {
  pname = "aiohue";
  version = "3.0.2";

  src = fetchFromGitHub {
     owner = "home-assistant-libs";
     repo = "aiohue";
     rev = "3.0.2";
     sha256 = "03sdqlc1k9dp4k8wna1rknflh8mkmwwj0r0b5wq5w3fik2mjr8gz";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  pythonImportsCheck = [
    "aiohue"
    "aiohue.discovery"
  ];

  # Project has no tests
  doCheck = false;

  meta = with lib; {
    description = "Python package to talk to Philips Hue";
    homepage = "https://github.com/home-assistant-libs/aiohue";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
