{ lib, buildPythonPackage
, fetchPypi, isPy3k, cython
, fastrlock, numpy, six, wheel, pytestCheckHook, mock, setuptools
, cudatoolkit, cudnn, cutensor, nccl
, addOpenGLRunpath
}:

buildPythonPackage rec {
  pname = "cupy";
  version = "9.5.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "2e85c3ac476c80c78ce94cae8786cc82a615fc4d1b0d380f16b9665d2cc5d187";
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
