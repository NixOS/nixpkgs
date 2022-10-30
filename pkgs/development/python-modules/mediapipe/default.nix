{ lib
, buildPythonPackage
, fetchPypi
, fetchurl
, python3
, pythonOlder
, pythonAtLeast
, gtk2
, pythonRelaxDepsHook
, autoPatchelfHook
}:
let
  pname = "mediapipe";
  version = "0.8.11";
  python =
    let
      packageOverrides = self:
        super: {
          opencv4 = super.opencv4.override {
            enableGtk2 = true;
            gtk2 = gtk2;
            enableFfmpeg = true; #here is how to add ffmpeg and other compilation flags
          };
        };
    in
    python3.override { inherit packageOverrides; self = python; };

in

buildPythonPackage rec {

  inherit pname version;
  disabled = pythonOlder "3.8" || pythonAtLeast "3.11";
  format = "wheel";
  doCheck = false;


  poseHeavy = fetchurl {
    url="https://storage.googleapis.com/mediapipe-assets/pose_landmark_heavy.tflite";
    sha256="sha256-WeQtcbzUTL26vEGfD/dmhllf0mVBlWa9QAnvcD6o4f4=";
  }; 

  src =
    let
      pyShortVersion = "cp${builtins.replaceStrings ["."] [""] python.pythonVersion}";
      binary-hash = (import ./binary-hashes.nix)."${pyShortVersion}";
    in
    fetchPypi ({
      inherit pname version format;
      dist = pyShortVersion;
      python = pyShortVersion;
      abi = pyShortVersion;
      platform = "manylinux_2_17_x86_64.manylinux2014_x86_64";
    } // binary-hash);

  nativeBuildInputs = [ pythonRelaxDepsHook autoPatchelfHook ];

  pythonRemoveDeps = [ "opencv-contrib-python" ];

  pythonRelaxDeps = [ "protobuf" ];

  propagatedBuildInputs = with python.pkgs;[
    opencv4
    numpy
    protobuf
    attrs
    absl-py
    matplotlib
  ];


  postInstall = ''
  cp ${poseHeavy} $out/${python.sitePackages}/mediapipe/modules/pose_landmark/pose_landmark_heavy.tflite
  '';


  pythonImportsCheck = [ "mediapipe" ];

  meta = with lib; {
    description = "MediaPipe";
    homepage = "https://github.com/google/mediapipe";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
