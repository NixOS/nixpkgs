{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pythonAtLeast,
  python,
  onnx,
  paddlepaddle,
}:
let
  pyShortVersion = "cp${builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion}";
in
buildPythonPackage (finallAttrs: {
  pname = "paddle2onnx";
  version = "2.0.1";

  src = fetchPypi {
    inherit (finallAttrs) pname version;
    format = "wheel";
    dist = pyShortVersion;
    python = pyShortVersion;
    abi = pyShortVersion;
    platform = "manylinux_2_24_x86_64.manylinux_2_28_x86_64";
    hash = "sha256-RCD6iTvzhGrFjW02lasTwQoM+Xa68Q5b6Ito3KvqdHg=";
  };

  format = "wheel";

  disabled = pythonOlder "3.12" || pythonAtLeast "3.13";

  dependencies = [
    onnx
    paddlepaddle
  ];

  meta = {
    description = "ONNX Model Exporter for PaddlePaddle";
    homepage = "https://github.com/PaddlePaddle/Paddle2ONNX";
    changelog = "https://github.com/PaddlePaddle/Paddle2ONNX/releases/tag/v${finallAttrs.version}";
    mainProgram = "paddle2onnx";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ happysalada ];
  };
})
