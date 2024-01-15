{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, async-timeout
}:

buildPythonPackage rec {
  pname = "ha-ffmpeg";
  version = "3.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sheNYtmp1panthglpEqJTdaCgGBTUJRswikl5hu9k7s=";
  };

  propagatedBuildInputs = [
    async-timeout
  ];

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
