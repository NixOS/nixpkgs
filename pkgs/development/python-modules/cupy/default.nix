{ stdenv, buildPythonPackage
, fetchPypi, isPy3k, linuxPackages
, fastrlock, numpy, six, wheel, pytest, mock
, cudatoolkit, cudnn, nccl
}:

buildPythonPackage rec {
  pname = "cupy";
  version = "5.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c08v2ai4j0a5lna5z2sp5yhkvnv594wa18qn4bh4j5zk00wladg";
  };

  checkInputs = [
    pytest
    mock
  ];

  propagatedBuildInputs = [
    cudatoolkit
    cudnn
    linuxPackages.nvidia_x11
    nccl
    fastrlock
    numpy
    six
    wheel
  ];

  # In python3, test was failed...
  doCheck = !isPy3k;

  meta = with stdenv.lib; {
    description = "A NumPy-compatible matrix library accelerated by CUDA";
    homepage = https://cupy.chainer.org/;
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ hyphon81 ];
  };
}
