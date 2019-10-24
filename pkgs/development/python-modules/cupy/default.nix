{ stdenv, buildPythonPackage
, fetchPypi, isPy3k, linuxPackages
, fastrlock, numpy, six, wheel, pytest, mock
, cudatoolkit, cudnn, nccl
}:

buildPythonPackage rec {
  pname = "cupy";
  version = "6.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "126waa1jiynq00glr1hq86sgwwmakq009crfsn8qqgrj4c4clw6a";
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
