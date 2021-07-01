{ lib, buildPythonPackage, fetchFromGitHub, isPy3k
, filelock, protobuf, numpy, pytestCheckHook, mock, typing-extensions
, cupy, cudaSupport ? false
}:

buildPythonPackage rec {
  pname = "chainer";
  version = "7.8.0";
  disabled = !isPy3k; # python2.7 abandoned upstream

  # no tests in Pypi tarball
  src = fetchFromGitHub {
    owner = "chainer";
    repo = "chainer";
    rev = "v${version}";
    sha256 = "1zfj3pk54gzxd4nid0qjx4kw1wdngwscvn4hk4cijxvwqi4a5zxj";
  };

  checkInputs = [
    pytestCheckHook
    mock
  ];

  propagatedBuildInputs = [
    filelock
    protobuf
    numpy
    typing-extensions
  ] ++ lib.optionals cudaSupport [ cupy ];

  pytestFlagsArray = [ "tests/chainer_tests/utils_tests" ];

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
