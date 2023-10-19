{ lib
, buildPythonPackage
, fetchPypi
, cython
, fastrlock
, numpy
, wheel
, pytestCheckHook
, mock
, setuptools
, cudaPackages
, addOpenGLRunpath
, pythonOlder
}:

let
  inherit (cudaPackages) cudatoolkit cudnn cutensor nccl;
in buildPythonPackage rec {
  pname = "cupy";
  version = "12.2.0";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+V/9Cv6sthewSP4Cjt4HuX3J6VrKFhCgIrHz0gqaAn4=";
  };

  # See https://docs.cupy.dev/en/v10.2.0/reference/environment.html. Seting both
  # CUPY_NUM_BUILD_JOBS and CUPY_NUM_NVCC_THREADS to NIX_BUILD_CORES results in
  # a small amount of thrashing but it turns out there are a large number of
  # very short builds and a few extremely long ones, so setting both ends up
  # working nicely in practice.
  preConfigure = ''
    export CUDA_PATH=${cudatoolkit}
    export CUPY_NUM_BUILD_JOBS="$NIX_BUILD_CORES"
    export CUPY_NUM_NVCC_THREADS="$NIX_BUILD_CORES"
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
    setuptools
    wheel
  ];

  nativeCheckInputs = [
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
    changelog = "https://github.com/cupy/cupy/releases/tag/v${version}";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ hyphon81 ];
  };
}
