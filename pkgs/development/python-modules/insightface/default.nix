{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  cython,
  setuptools,

  # dependencies
  mxnet,
  numpy,
  onnx,
  onnxruntime,
  opencv-python,
  requests,
  scikit-image,
  scipy,
  tqdm,

  # optional-dependencies
  # gui:
  pillow,
  pyside6,
  reportlab,
  scikit-learn,
  # face3d
  albumentationsx,
  matplotlib,

  insightface,
  testers,
  stdenv,
}:

buildPythonPackage (finalAttrs: {
  pname = "insightface";
  version = "1.0.1";
  pyproject = true;
  __structuredAttrs = true;

  # No tags on GitHub
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-J68kiRu7pHDLNXOzZqD8yomJ/IUDyfjygejLpv1xYHU=";
  };

  build-system = [
    cython
    setuptools
  ];

  dependencies = [
    mxnet # used in insightface/commands/rec_add_mask_param.py
    numpy
    onnx
    onnxruntime
    opencv-python
    requests
    scikit-image
    scipy
    tqdm
  ];

  optional-dependencies = {
    gui = [
      pillow
      pyside6
      reportlab
      scikit-learn
    ];
    face3d = [
      albumentationsx
      matplotlib
    ];
  };

  pythonImportsCheck = [
    "insightface"
    "insightface.app"
    "insightface.data"
  ];

  # No tests in the Pypi archive
  doCheck = false;

  passthru.tests = {
    version = testers.testVersion {
      package = insightface;
      command = "insightface-cli --help";
      # Doesn't support --version but we still want to make sure the cli is executable
      # and returns the help output
      version = "help";
    };
  };

  meta = {
    description = "State-of-the-art 2D and 3D Face Analysis Project";
    mainProgram = "insightface-cli";
    homepage = "https://github.com/deepinsight/insightface";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oddlama ];
  };
})
