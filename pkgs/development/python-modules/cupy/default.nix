{ lib, stdenv, buildPythonPackage
, fetchPypi, isPy3k, linuxPackages
, fastrlock, numpy, six, wheel, pytest, mock, setuptools
, cudatoolkit, cudnn, nccl
}:

buildPythonPackage rec {
  pname = "cupy";
  version = "8.3.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "db699fddfde7806445908cf6454c6f4985e7a9563b40405ddf97845d808c5f12";
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
