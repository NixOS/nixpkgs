{ lib
, fetchurl
, buildPythonPackage
, protobuf
, numpy
, opencv4
, attrs
, matplotlib
, autoPatchelfHook
}:

buildPythonPackage {
  pname = "mediapipe";
  version = "0.10.7";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/52/92/a2b0f9a943ebee88aa9dab040535ea05908ec102b8052b28c645cf0ac25b/mediapipe-0.10.7-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
    sha256 = "sha256-88kAkpxRn4Pj+Ib95WNj+53P36gHjpFt5rXlaX4bpco=";
  };

  propagatedBuildInputs = [ protobuf numpy opencv4 matplotlib attrs ];

  nativeBuildInputs = [ autoPatchelfHook ];

  pythonImportsCheck = [ "mediapipe" ];

  meta = with lib; {
    description = "Cross-platform, customizable ML solutions for live and streaming media";
    homepage = "https://github.com/google/mediapipe/releases/tag/v0.10.7";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
