{ lib
, fetchFromGitHub
, setuptools
, buildPythonPackage
, onnx
, numpy
}:

buildPythonPackage {
  pname = "onnx-graphsurgeon";
  version = "0.3.25";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "TensorRT";
    rev = "8.5.2";
    hash = "sha256-IvfMj1/m8NXEOHQdGTFMCy4ra1DuxFCEIDWvwymh7PU=";
    sparseCheckout = [
      "tools/onnx-graphsurgeon"
    ];
  };

  preBuild = "cd tools/onnx-graphsurgeon";

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    onnx
    numpy
  ];

  pythonImportsCheck = [
    "onnx_graphsurgeon"
  ];

  meta = with lib; {
    description = "Provides a convenient way to create and modify ONNX models";
    homepage = "https://github.com/nvidia/tensorrt/tools/onnx-graphsurgeon";
    license = licenses.asl20;
    maintainers = with maintainers; [ yelite ];
  };
}
