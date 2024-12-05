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
  pillow,
  prettytable,
  pythonOlder,
  requests,
  setuptools,
  scipy,
  scikit-image,
  scikit-learn,
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

  build-system = [
    cython
    setuptools
  ];

  dependencies = [
    albumentations
    easydict
    matplotlib
    mxnet # used in insightface/commands/rec_add_mask_param.py
    numpy
    onnx
    onnxruntime
    opencv4
    pillow
    prettytable
    requests
    scikit-learn
    scikit-image
    scipy
    tqdm
  ];

  # aarch64-linux tries to get cpu information from /sys, which isn't available
  # inside the nix build sandbox.
  dontUsePythonImportsCheck = stdenv.buildPlatform.system == "aarch64-linux";

  passthru.tests = lib.optionalAttrs (stdenv.buildPlatform.system != "aarch64-linux") {
    version = testers.testVersion {
      package = insightface;
      command = "insightface-cli --help";
      # Doesn't support --version but we still want to make sure the cli is executable
      # and returns the help output
      version = "help";
    };
  };

  pythonImportsCheck = [
    "insightface"
    "insightface.app"
    "insightface.data"
  ];

  doCheck = false; # Upstream has no tests

  meta = {
    description = "State-of-the-art 2D and 3D Face Analysis Project";
    mainProgram = "insightface-cli";
    homepage = "https://github.com/deepinsight/insightface";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oddlama ];
  };
}
