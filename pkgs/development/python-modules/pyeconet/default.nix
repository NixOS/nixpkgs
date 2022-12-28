{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, paho-mqtt
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pyeconet";
  version = "0.1.17";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "w1ll1am23";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ntxITedoJOt5d7V9TSFQHg0oqBEw8jNGeDLM00RRWHI=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    paho-mqtt
    aiohttp
  ];

  # Tests require credentials
  doCheck = false;

  pythonImportsCheck = [
    "pyeconet"
  ];

  meta = with lib; {
    description = "Python interface to the EcoNet API";
    homepage = "https://github.com/w1ll1am23/pyeconet";
    changelog = "https://github.com/w1ll1am23/pyeconet/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
