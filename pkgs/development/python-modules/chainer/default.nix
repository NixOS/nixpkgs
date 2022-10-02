{ config, lib, buildPythonPackage, fetchFromGitHub, isPy3k
, filelock, protobuf, numpy, pytestCheckHook, mock, typing-extensions
, cupy, cudaSupport ? config.cudaSupport or false
}:

buildPythonPackage rec {
  pname = "chainer";
  version = "7.8.1.post1";
  disabled = !isPy3k; # python2.7 abandoned upstream

  src = fetchFromGitHub {
    owner = "chainer";
    repo = "chainer";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-epwnExmyCWmwaOz+mJnAl1peEeHLBdQGC62BlLfSTQQ=";
  };

  propagatedBuildInputs = [
    filelock
    protobuf
    numpy
    typing-extensions
  ] ++ lib.optionals cudaSupport [ cupy ];

  checkInputs = [
    pytestCheckHook
    mock
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

  meta = with lib; {
    description = "A flexible framework of neural networks for deep learning";
    homepage = "https://chainer.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
