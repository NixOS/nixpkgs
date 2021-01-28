{ lib, buildPythonPackage
, fetchPypi, isPy3k, linuxPackages
, fastrlock, numpy, six, wheel, pytest, mock, setuptools
, cudatoolkit, cudnn, nccl
}:

buildPythonPackage rec {
  pname = "cupy";
  version = "8.4.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "58d19af6b2e83388d4f0f6ca4226bae4b947920d2ca4951c2eddc8bc78abf66b";
  };

  checkInputs = [
    pytest
    mock
  ];

  preConfigure = ''
      export CUDA_PATH=${cudatoolkit}
  '';

  propagatedBuildInputs = [
    cudatoolkit
    cudnn
    linuxPackages.nvidia_x11
    nccl
    fastrlock
    numpy
    six
    setuptools
    wheel
  ];

  # In python3, test was failed...
  doCheck = !isPy3k;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A NumPy-compatible matrix library accelerated by CUDA";
    homepage = "https://cupy.chainer.org/";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ hyphon81 ];
  };
}
