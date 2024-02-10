{
  lib,
  buildPythonPackage,
  pythonOlder,
  pythonAtLeast,
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
  pydantic,
  requests,
  sparsezoo,
  tqdm,
  protobuf,

  # checks
  ndjson,
  pytestCheckHook,
  torchvision,
}:

buildPythonPackage rec {
  pname = "deepsparse";
  version = "1.8.0";
  pyproject = true;

  # disabled = pythonOlder "3.8" || pythonAtLeast "3.12";

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
    pydantic
    sparsezoo
    requests
    tqdm
    protobuf
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
