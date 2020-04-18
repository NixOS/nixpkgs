{ lib, buildPythonPackage, fetchFromGitHub, isPy3k
, filelock, protobuf, numpy, pytest, mock, typing-extensions
, cupy, cudaSupport ? false
}:

buildPythonPackage rec {
  pname = "chainer";
  version = "6.5.0";
  disabled = !isPy3k; # python2.7 abandoned upstream

  # no tests in Pypi tarball
  src = fetchFromGitHub {
    owner = "chainer";
    repo = "chainer";
    rev = "v${version}";
    sha256 = "0ha9fbl6sa3fbnsz3y1pg335iiskdbxw838m5j06zgzy156zna1x";
  };

  # remove on 7.0 or 6.6 release
  postPatch = ''
    sed -i '/typing/d' setup.py
  '';

  checkInputs = [
    pytest
    mock
  ];

  propagatedBuildInputs = [
    filelock
    protobuf
    numpy
    typing-extensions
  ] ++ lib.optionals cudaSupport [ cupy ];

  # avoid gpu tests
  checkPhase = ''
    pytest tests/chainer_tests/utils_tests -k 'not gpu and not cupy'
  '';

  meta = with lib; {
    description = "A flexible framework of neural networks for deep learning";
    homepage = "https://chainer.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
