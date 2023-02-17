{ lib, buildPythonPackage, fetchPypi, isPy3k
, async-timeout }:

buildPythonPackage rec {
  pname = "ha-ffmpeg";
  version = "3.1.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-sheNYtmp1panthglpEqJTdaCgGBTUJRswikl5hu9k7s=";
  };

  propagatedBuildInputs = [ async-timeout ];

  # only manual tests
  doCheck = false;

  pythonImportsCheck = [
    "haffmpeg.camera"
    "haffmpeg.sensor"
    "haffmpeg.tools"
  ];

  meta = with lib; {
    homepage = "https://github.com/pvizeli/ha-ffmpeg";
    description = "Library for home-assistant to handle ffmpeg";
    license = licenses.bsd3;
    maintainers = teams.home-assistant.members;
  };
}
