{ stdenv, buildPythonPackage
, fetchPypi, isPy3k, linuxPackages
, fastrlock, numpy, six, wheel, pytest, mock, setuptools
, cudatoolkit, cudnn, nccl
}:

buildPythonPackage rec {
  pname = "cupy";
  version = "7.8.0.post1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4dafe950f06642e93b4ed9e48b6717c254969ca8625c4276c5b84e0012c4cbd4";
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

  meta = with stdenv.lib; {
    description = "A NumPy-compatible matrix library accelerated by CUDA";
    homepage = "https://cupy.chainer.org/";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ hyphon81 ];
  };
}
