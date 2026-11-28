{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pythonAtLeast,
  python,
  onnx,
  paddlepaddle,
  nix-update-script,
}:
let
  pyShortVersion = "cp${builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion}";
in
buildPythonPackage (finallAttrs: {
  pname = "paddle2onnx";
  version = "2.1.0";

  src = fetchPypi {
    inherit (finallAttrs) pname version;
    format = "wheel";
    dist = pyShortVersion;
    python = pyShortVersion;
    abi = pyShortVersion;
    platform = "manylinux_2_24_x86_64.manylinux_2_28_x86_64";
    hash = "sha256-f+8D1sQLvl4uvG6JWyW4hgrNKIA2ARlYhOj/7F/6EQk=";
  };

  format = "wheel";

  disabled = pythonOlder "3.12" || pythonAtLeast "3.13";

  dependencies = [
    onnx
    paddlepaddle
  ];

  passthru.updateScript = nix-update-script { };

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
