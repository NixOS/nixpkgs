{ lib
, absl-py
, attrs
, autoPatchelfHook
, buildPythonPackage
, fetchPypi
, fetchurl
, flatbuffers
, gtk2
, matplotlib
, numpy
, opencv4
, protobuf
, python
, pythonAtLeast
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "mediapipe";
  version = "0.9.2.1";
  disabled = pythonOlder "3.8" || pythonAtLeast "3.11";
  format = "wheel";

  poseHeavy = fetchurl {
    url = "https://storage.googleapis.com/mediapipe-assets/pose_landmark_heavy.tflite";
    sha256 = "WeQtcbzUTL26vEGfD/dmhllf0mVBlWa9QAnvcD6o4f4=";
  };

  src =
    let
      pyShortVersion = "cp${builtins.replaceStrings ["."] [""] python.pythonVersion}";
    in
    fetchPypi {
      inherit pname version format;
      dist = pyShortVersion;
      python = pyShortVersion;
      abi = pyShortVersion;
      platform = "manylinux_2_17_x86_64.manylinux2014_x86_64";
      sha256 = "8LSgTccNA3D+9sBdOGHVgw/chdLAwGWxdhNwLgiRvdE=";
    };

  nativeBuildInputs = [ pythonRelaxDepsHook autoPatchelfHook ];

  pythonRemoveDeps = [ "opencv-contrib-python" ];

  pythonRelaxDeps = [ "protobuf" ];

  propagatedBuildInputs = [
    absl-py
    attrs
    flatbuffers
    matplotlib
    numpy
    opencv4
    protobuf
  ];

  # has no tests
  doCheck = false;

  postInstall = ''
    ln -s ${poseHeavy} $out/${python.sitePackages}/mediapipe/modules/pose_landmark/pose_landmark_heavy.tflite
  '';

  pythonImportsCheck = [ "mediapipe" ];

  meta = with lib; {
    description = "MediaPipe offers cross-platform, customizable ML solutions for live and streaming media";
    homepage = "https://mediapipe.dev";
    changelog = "https://github.com/google/mediapipe/blob/v${version}";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ derdennisop ];
  };
}

