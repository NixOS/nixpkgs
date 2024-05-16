{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pulsectl,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pulsectl-asyncio";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mhthies";
    repo = "pulsectl-asyncio";
    rev = "refs/tags/v${version}";
    hash = "sha256-WqUO4eERJkRg6O+gCmjqfdVbBT/3TVVBUUduoIxcPNQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ pulsectl ];

  # Tests require a running pulseaudio instance
  doCheck = false;

  pythonImportsCheck = [ "pulsectl_asyncio" ];

  meta = with lib; {
    description = "Python bindings library for PulseAudio";
    homepage = "https://github.com/mhthies/pulsectl-asyncio";
    changelog = "https://github.com/mhthies/pulsectl-asyncio/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
