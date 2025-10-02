{
  lib,
  buildPythonPackage,
  fetchPypi,

  # dependencies
  coloredlogs,
  numpy,
  onnx,
  packaging,
  psutil,
  py-cpuinfo,
  py3nvml,
  sympy,
}:

buildPythonPackage rec {
  pname = "onnxruntime-tools";
  version = "1.7.0";
  format = "wheel";

  # the build distribution doesn't work at all, it seems to expect the same structure
  # as the github source repo.
  # The github source wasn't immediately obvious how to build for this subpackage.
  src = fetchPypi {
    pname = "onnxruntime_tools";
    inherit version;
    format = "wheel";
    dist = "py3";
    python = "py3";
    hash = "sha256-Hf+Ii1xIKsW8Yn8S4QhEX+/LPWAMQ/Y2M5dTFv5hetg=";
  };

  dependencies = [
    coloredlogs
    numpy
    onnx
    packaging
    psutil
    py-cpuinfo
    py3nvml
    sympy
  ];

  pythonImportsCheck = [ "onnxruntime_tools" ];

  # no tests
  doCheck = false;

  meta = {
    description = "Transformers Model Optimization Tool of ONNXRuntime";
    homepage = "https://pypi.org/project/onnxruntime-tools/";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
