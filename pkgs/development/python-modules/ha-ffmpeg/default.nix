{ lib, buildPythonPackage, fetchFromGitHub, isPy3k
, async-timeout }:

buildPythonPackage rec {
  pname = "ha-ffmpeg";
  version = "3.0.2";

  disabled = !isPy3k;

  src = fetchFromGitHub {
     owner = "pvizeli";
     repo = "ha-ffmpeg";
     rev = "3.0.2";
     sha256 = "0xh54f1m0c5y145dnm1hv18n0kk0d0iy44gd3jwil7gjfn7q98q6";
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
