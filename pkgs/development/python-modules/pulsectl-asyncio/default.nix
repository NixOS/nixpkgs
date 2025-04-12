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
  version = "1.2.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mhthies";
    repo = "pulsectl-asyncio";
    rev = "refs/tags/v${version}";
    hash = "sha256-lHVLrkFdNM8Y4t6TcXYnX8sQ4COrW3vV2sTDWeI4xZU=";
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
