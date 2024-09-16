{
  lib,
  buildPythonPackage,
  config,
  cudaSupport ? config.cudaSupport,
  cupy,
  fetchFromGitHub,
  filelock,
  mock,
  numpy,
  protobuf,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  six,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "chainer";
  version = "7.8.1.post1";
  format = "setuptools";

  # Uses NumPy's distutils, which are removed in Python 3.12.
  disabled = pythonOlder "3.7" || pythonAtLeast "3.12";

  src = fetchFromGitHub {
    owner = "chainer";
    repo = "chainer";
    rev = "refs/tags/v${version}";
    hash = "sha256-epwnExmyCWmwaOz+mJnAl1peEeHLBdQGC62BlLfSTQQ=";
  };

  propagatedBuildInputs = [
    filelock
    numpy
    protobuf
    six
    typing-extensions
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

  # The checks require access to the GPU.
  doCheck = config.cudaSupport;

  pythonImportsCheck = [ "chainer" ];

  meta = with lib; {
    description = "Flexible framework of neural networks for deep learning";
    homepage = "https://chainer.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
