{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  async-timeout,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ha-ffmpeg";
  version = "3.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FW8WlrhVL+ryupHAKii8fKBku/6uxdw1uLCKUszkP50=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ async-timeout ];

  # only manual tests
  doCheck = false;

  pythonImportsCheck = [
    "haffmpeg.camera"
    "haffmpeg.sensor"
    "haffmpeg.tools"
  ];

  meta = with lib; {
    description = "Library for Home Assistant to handle ffmpeg";
    homepage = "https://github.com/home-assistant-libs/ha-ffmpeg/";
    changelog = "https://github.com/home-assistant-libs/ha-ffmpeg/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = teams.home-assistant.members;
  };
}
