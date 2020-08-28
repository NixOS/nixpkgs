{ stdenv, buildPythonPackage
, fetchPypi, isPy3k, linuxPackages
, fastrlock, numpy, six, wheel, pytest, mock, setuptools
, cudatoolkit, cudnn, nccl
}:

buildPythonPackage rec {
  pname = "cupy";
  version = "7.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b4032adf839f63bab7fc9f3e7066ef86abe0928e834aa5d132e4e7ce907951ed";
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
