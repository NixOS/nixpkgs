{ stdenv, buildPythonPackage
, fetchPypi, isPy3k, linuxPackages, gcc5
, fastrlock, numpy, six, wheel, pytest, mock
, cudatoolkit, cudnn, nccl
}:

buildPythonPackage rec {
  pname = "cupy";
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3e714fa21401ab1d278b648543fae56fbce97e389076ebf03b4189f88c2d61e0";
  };

  checkInputs = [
    pytest
    mock
  ];

  nativeBuildInputs = [
    gcc5
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
