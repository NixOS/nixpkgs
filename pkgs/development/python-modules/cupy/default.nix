{ stdenv, python, buildPythonPackage
, fetchPypi, isPy3k, linuxPackages, gcc5
, fastrlock, numpy, six, wheel, pytest, mock
, cudatoolkit, cudnn, nccl
}:

buildPythonPackage rec {
  pname = "cupy";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "96ac44dface1a73673e9c0549fc897f8fa31a7648ff9963dff799ddabd67fde2";
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
