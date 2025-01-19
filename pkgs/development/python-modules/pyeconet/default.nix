{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  paho-mqtt,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyeconet";
  version = "0.1.25";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "w1ll1am23";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-qbg8QzzT81fmjFeyEgVPXp3QKGOs3oKjTUUUTHIR8OI=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    paho-mqtt
    aiohttp
  ];

  # Tests require credentials
  doCheck = false;

  pythonImportsCheck = [ "pyeconet" ];

  meta = with lib; {
    description = "Python interface to the EcoNet API";
    homepage = "https://github.com/w1ll1am23/pyeconet";
    changelog = "https://github.com/w1ll1am23/pyeconet/releases/tag/${src.tag}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
