{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  async-timeout,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ha-ffmpeg";
  version = "3.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "ha-ffmpeg";
    tag = version;
    hash = "sha256-TbSoKoOiLx3O7iykiTri5GBHGj7WoB8iSCpFIrV4ZgU=";
  };

  build-system = [ setuptools ];

  pythonRemoveDeps = [
    "async_timeout"
  ];

  dependencies = lib.optionals (pythonOlder "3.11") [
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
    teams = [ teams.home-assistant ];
  };
}
