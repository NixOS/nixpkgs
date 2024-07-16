{
  lib,
  albumentations,
  buildPythonPackage,
  cython,
  easydict,
  fetchPypi,
  insightface,
  matplotlib,
  mxnet,
  numpy,
  onnx,
  onnxruntime,
  opencv4,
  prettytable,
  pythonOlder,
  scikit-image,
  scikit-learn,
  tensorboard,
  testers,
  tqdm,
  stdenv,
}:

buildPythonPackage rec {
  pname = "insightface";
  version = "0.7.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8ZH3GWEuuzcBj0GTaBRQBUTND4bm/NZ2wCPzVMZo3fc=";
  };

  build-system = [ cython ];

  dependencies = [
    easydict
    matplotlib
    mxnet
    numpy
    onnx
    onnxruntime
    opencv4
    scikit-learn
    scikit-image
    tensorboard
    tqdm
    albumentations
    prettytable
  ];

  pythonImportsCheck = [
    "insightface"
    "insightface.app"
    "insightface.data"
  ];

  passthru.tests.version = testers.testVersion {
    package = insightface;
    command = "insightface-cli --help";
    # Doesn't support --version but we still want to make sure the cli is executable
    # and returns the help output
    version = "help";
  };

  doCheck = false; # Upstream has no tests

  meta = {
    description = "State-of-the-art 2D and 3D Face Analysis Project";
    mainProgram = "insightface-cli";
    homepage = "https://github.com/deepinsight/insightface";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oddlama ];
    # terminate called after throwing an instance of 'onnxruntime::OnnxRuntimeException'
    broken = stdenv.system == "aarch64-linux";
  };
}
