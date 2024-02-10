{
  lib,
  buildPythonPackage,
  fetchPypi,
  autoPatchelfHook,
  pythonRelaxDepsHook,
  setuptools,
  wheel,
  click,
  onnx,
  numpy,
  pydantic_1,
  requests,
  sparsezoo,
  tqdm,
  protobuf,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "deepsparse";
  version = "1.7.1";
  pyproject = true;

  # Using pypi rather than GitHub build because it already contains the required proprietary binaries.
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8gjeY/4XOaIIQiCod6cYGywWWZY1QF9pN2ew4P18L40=";
  };

  pythonRelaxDeps = [ "onnx" ];

  nativeBuildInputs = [
    # Necessary to patch deepsparse/arch.bin
    autoPatchelfHook
  ];

  build-system = [
    pythonRelaxDepsHook
    setuptools
    wheel
  ];

  dependencies = [
    click
    numpy
    onnx
    pydantic_1
    sparsezoo
    requests
    tqdm
    protobuf
  ];

  pythonImportsCheck = [ "deepsparse" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Sparsity-aware deep learning inference runtime for CPUs";
    homepage = "https://github.com/neuralmagic/deepsparse";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
