{ lib, buildPythonPackage
, fetchPypi, isPy3k, cython
, fastrlock, numpy, six, wheel, pytestCheckHook, mock, setuptools
, cudatoolkit, cudnn, cutensor, nccl
, addOpenGLRunpath
}:

buildPythonPackage rec {
  pname = "cupy";
  version = "10.1.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ad28e7311b2023391f2278b7649828decdd9d9599848e18845eb4ab1b2d01936";
  };

  preConfigure = ''
    export CUDA_PATH=${cudatoolkit}
  '';

  nativeBuildInputs = [
    addOpenGLRunpath
    cython
  ];

  LDFLAGS = "-L${cudatoolkit}/lib/stubs";

  propagatedBuildInputs = [
    cudatoolkit
    cudnn
    cutensor
    nccl
    fastrlock
    numpy
    six
    setuptools
    wheel
  ];

  checkInputs = [
    pytestCheckHook
    mock
  ];

  # Won't work with the GPU, whose drivers won't be accessible from the build
  # sandbox
  doCheck = false;

  postFixup = ''
    find $out -type f \( -name '*.so' -or -name '*.so.*' \) | while read lib; do
      addOpenGLRunpath "$lib"
    done
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A NumPy-compatible matrix library accelerated by CUDA";
    homepage = "https://cupy.chainer.org/";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ hyphon81 ];
  };
}
