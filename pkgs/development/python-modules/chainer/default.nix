{
  lib,
  buildPythonPackage,
  config,
  cudaSupport ? config.cudaSupport,
  cupy,
  fetchFromGitHub,
  filelock,
  mock,
  protobuf,
  pytestCheckHook,
  pythonOlder,
  six,
  setuptools,
  numpy,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "chainer";
  version = "7.8.1.post1";
  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "chainer";
    repo = "chainer";
    rev = "refs/tags/v${version}";
    hash = "sha256-epwnExmyCWmwaOz+mJnAl1peEeHLBdQGC62BlLfSTQQ=";
  };

  postPatch = ''
    substituteInPlace chainer/_environment_check.py \
      --replace-fail "import numpy.distutils.system_info" "import numpy" \
      --replace-fail "numpy.distutils.system_info" "numpy.__config__.get_info"
  '';

  dependencies = [
    filelock
    protobuf
    six
    typing-extensions
    numpy
  ] ++ lib.optionals cudaSupport [ cupy ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/chainer_tests/utils_tests" ];

  preCheck = ''
    # cf. https://github.com/chainer/chainer/issues/8621
    export CHAINER_WARN_VERSION_MISMATCH=0

    # ignore pytest warnings not listed
    rm setup.cfg
  '';

  disabledTests = [
    "gpu"
    "cupy"
    "ideep"
  ];

  pythonImportsCheck = [ "chainer" ];

  meta = {
    description = "Flexible framework of neural networks for deep learning";
    homepage = "https://chainer.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hyphon81 ];
  };
}
