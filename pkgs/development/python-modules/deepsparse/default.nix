{
  lib,
  buildPythonPackage,
  fetchPypi,

  # nativeBuildInputs
  autoPatchelfHook,
  pythonRelaxDepsHook,

  # build-system
  setuptools,

  # dependencies
  click,
  numpy,
  onnx,
  protobuf,
  pydantic,
  requests,
  sparsezoo,
  tqdm,

  # checks
  ndjson,
  pytestCheckHook,
  torchvision,
}:

buildPythonPackage rec {
  pname = "deepsparse";
  version = "1.8.0";
  pyproject = true;

  # Using pypi rather than GitHub build because it already contains the required proprietary binaries.
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RhcU0NERiwsxgTm7DCp7XJ+s3numjRnT0Ys0AFeSwZg=";
  };

  nativeBuildInputs = [
    # Necessary to patch deepsparse/arch.bin
    autoPatchelfHook
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [ "onnx" ];

  build-system = [ setuptools ];

  dependencies = [
    click
    numpy
    onnx
    protobuf
    pydantic
    requests
    sparsezoo
    tqdm
  ];

  pythonImportsCheck = [ "deepsparse" ];

  nativeCheckInputs = [
    ndjson
    pytestCheckHook
    torchvision
  ];

  meta = {
    description = "Sparsity-aware deep learning inference runtime for CPUs";
    homepage = "https://github.com/neuralmagic/deepsparse";
    changelog = "https://github.com/neuralmagic/deepsparse/releases/tag/v${version}";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
