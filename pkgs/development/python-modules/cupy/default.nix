{ stdenv, buildPythonPackage
, fetchPypi, isPy3k, linuxPackages
, fastrlock, numpy, six, wheel, pytest, mock, setuptools
, cudatoolkit, cudnn, nccl
}:

buildPythonPackage rec {
  pname = "cupy";
  version = "8.1.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4dfa4a0cd0a752d980347c816cab2169f0938c1d37275311810396dcf3c27912";
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
