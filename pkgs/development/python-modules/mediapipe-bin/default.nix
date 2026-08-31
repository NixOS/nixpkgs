{ lib
, buildPythonPackage
, fetchPypi
, ffmpeg
, opencv4
, numpy
, cycler
, fonttools
, kiwisolver
, matplotlib
, pillow
, protobuf
, absl-py
, pythonOlder
, pythonAtLeast
, python
}:
let
  abi = "cp310";
in
buildPythonPackage rec{
  pname = "mediapipe-bin";
  version = "0.10.5";
  #Wheel has been compiled specifically for cython 3.10
  disabled = pythonOlder "3.10" || pythonAtLeast "3.11" || python.implementation != "cpython";

  src = fetchPypi {
    inherit version format abi;
    pname = "mediapipe";
    dist = abi;
    python = abi;
    platform = "manylinux_2_17_x86_64.manylinux2014_x86_64";
    hash = "sha256-lBD8mgs00e3QC1/23fVP1JZIUn+n6G25+BdELEwIDV0=";
  };

  format = "wheel";
  # otherwise opencv-contrib-python (aka opencv) will be missed
  #yes, this does mean that every dependency requires the below line
  pipInstallFlags = [ "--no-deps" ];
  propagatedBuildInputs = [
    ffmpeg
    opencv4
    numpy
    cycler
    fonttools
    kiwisolver
    matplotlib
    pillow
    protobuf
    absl-py
  ];

  meta = with lib;{
    homepage = "https://github.com/google/mediapipe";
    license = licenses.asl20;
    description = "MediaPipe is the simplest way for researchers and developers to build world-class ML solutions";
    mantainers = with mantainers;[ pasqui023 ];
  };
}
