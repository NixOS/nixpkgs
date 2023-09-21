{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, opencv4
, torch
, onnx
, onnxruntime
, pillow
, pywavelets
, numpy
}:

buildPythonPackage rec {
  pname = "invisible-watermark";
  version = "0.1.5";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ShieldMnt";
    repo = "invisible-watermark";
    rev = version;
    hash = "sha256-NGDPEETuM7rYbo8kXYoRWLJWpa/lWLKEvaaiDzSWYZ4=";
  };

  propagatedBuildInputs = [
    opencv4
    torch
    onnx
    onnxruntime
    pillow
    pywavelets
    numpy
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'opencv-python>=4.1.0.25' 'opencv'
  '';

  pythonImportsCheck = [ "imwatermark" ];

  meta = with lib; {
    description = "A library for creating and decoding invisible image watermarks";
    homepage = "https://github.com/ShieldMnt/invisible-watermark";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
  };
}
