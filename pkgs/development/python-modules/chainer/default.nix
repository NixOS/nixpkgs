{ config, lib, buildPythonPackage, fetchFromGitHub, isPy3k
, filelock, protobuf, numpy, pytestCheckHook, mock, typing-extensions
, cupy, cudaSupport ? config.cudaSupport or false
}:

buildPythonPackage rec {
  pname = "chainer";
  version = "7.8.1";
  disabled = !isPy3k; # python2.7 abandoned upstream

  # no tests in Pypi tarball
  src = fetchFromGitHub {
    owner = "chainer";
    repo = "chainer";
    rev = "v${version}";
    sha256 = "1n07zjzc4g92m1sbgxvnansl0z00y4jnhma2mw06vnahs7s9nrf6";
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
    # Un-break me when updating chainer next time!
    broken = cudaSupport && (lib.versionAtLeast cupy.version "8.0.0");
    license = licenses.mit;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
