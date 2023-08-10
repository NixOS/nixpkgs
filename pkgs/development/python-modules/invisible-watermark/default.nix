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
, withOnnx ? false # Enables the rivaGan en- and decoding method
}:

buildPythonPackage rec {
  pname = "invisible-watermark";
  version = "0.2.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ShieldMnt";
    repo = "invisible-watermark";
    rev = "e58e451cff7e092457cd915e445b1a20b64a7c8f"; # No git tag, see https://github.com/ShieldMnt/invisible-watermark/issues/22
    hash = "sha256-6SjVpKFtiiLLU7tZ3hBQr0KT/YEQyywJj0e21/dJRzk=";
  };

  propagatedBuildInputs = [
    opencv4
    torch
    pillow
    pywavelets
    numpy
  ] ++ lib.optionals withOnnx [
    onnx
    onnxruntime
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'opencv-python>=4.1.0.25' 'opencv'
    substituteInPlace imwatermark/rivaGan.py --replace \
      'You can install it with pip: `pip install onnxruntime`.' \
      'You can install it with an override: `python3Packages.invisible-watermark.override { withOnnx = true; };`.'
  '';

  pythonImportsCheck = [ "imwatermark" ];

  meta = with lib; {
    description = "A library for creating and decoding invisible image watermarks";
    homepage = "https://github.com/ShieldMnt/invisible-watermark";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
  };
}
