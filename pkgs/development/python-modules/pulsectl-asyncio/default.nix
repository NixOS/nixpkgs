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
    tag = "v${version}";
    hash = "sha256-lHVLrkFdNM8Y4t6TcXYnX8sQ4COrW3vV2sTDWeI4xZU=";
  };

  postPatch = ''
    substituteInPlace setup.cfg --replace-fail "pulsectl >=23.5.0,<=24.11.0" "pulsectl >=23.5.0"
  '';

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
