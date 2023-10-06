{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, python
, onnx
, isPy311
}:
let
  pname = "paddle2onnx";
  version = "1.0.6";
  format = "wheel";
  pyShortVersion = "cp${builtins.replaceStrings ["."] [""] python.pythonVersion}";
  src = fetchPypi {
    inherit pname version format;
    dist = pyShortVersion;
    python = pyShortVersion;
    abi = pyShortVersion;
    platform = "manylinux_2_12_x86_64.manylinux2010_x86_64";
    hash = "sha256-qHy6+RKh/gjy1mBmIj+1ENcHuIERkOeM6rrd5GNfX+Q=";
  };
in
buildPythonPackage {
  inherit pname version src format;

  disabled = pythonOlder "3.8" || isPy311;

  propagatedBuildInputs = [
    onnx
  ];

  meta = with lib; {
    description = "ONNX Model Exporter for PaddlePaddle";
    homepage = "https://github.com/PaddlePaddle/Paddle2ONNX";
    changelog = "https://github.com/PaddlePaddle/Paddle2ONNX/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ happysalada ];
  };
}
