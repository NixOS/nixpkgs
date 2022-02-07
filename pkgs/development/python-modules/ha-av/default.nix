{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pkg-config
, ffmpeg_4
}:

buildPythonPackage rec {
  pname = "ha-av";
  version = "8.0.4rc1";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-txdi2/X6upqrACeHhHpEh4tGqgPpW/dyWda8y++7c3M=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    ffmpeg_4
  ];

  pythonImportsCheck = [
    "av"
    "av._core"
  ];

  # tests fail to import av._core
  doCheck = false;

  meta = with lib; {
    homepage = "https://pypi.org/project/ha-av/";
    description = "Pythonic bindings for FFmpeg's libraries";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
