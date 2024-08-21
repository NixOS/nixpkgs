{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython_0,
  fastrlock,
  numpy,
  wheel,
  pytestCheckHook,
  mock,
  setuptools,
  cudaPackages,
  addDriverRunpath,
  pythonOlder,
  symlinkJoin,
  fetchpatch
}:

let
  inherit (cudaPackages) cudnn cutensor nccl;
  outpaths = with cudaPackages; [
      cuda_cccl # <nv/target>
      cuda_cudart
      cuda_nvcc # <crt/host_defines.h>
      cuda_nvprof
      cuda_nvrtc
      cuda_nvtx
      cuda_profiler_api
      libcublas
      libcufft
      libcurand
      libcusolver
      libcusparse

      # Missing:
      # cusparselt
  ];
  cudatoolkit-joined = symlinkJoin {
    name = "cudatoolkit-joined-${cudaPackages.cudaVersion}";
    paths = outpaths ++ lib.concatMap (f: lib.map f outpaths) [lib.getLib lib.getDev (lib.getOutput "static") (lib.getOutput "stubs")];
  };
in
buildPythonPackage rec {
  pname = "cupy";
  version = "13.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cupy";
    repo = "cupy";
    rev = "v13.2.0";
    hash = "sha256-vZAtpIZztmsYeJeuq7yl7kgZse2azrIM3efHDmUswJI=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      url =
        "https://github.com/cfhammill/cupy/commit/67526c756e4a0a70f0420bf0e7f081b8a35a8ee5.patch";
      hash = "sha256-WZgexBdM9J0ep5s+9CGZriVq0ZidCRccox+g0iDDywQ=";
    })
  ];

  # See https://docs.cupy.dev/en/v10.2.0/reference/environment.html. Seting both
  # CUPY_NUM_BUILD_JOBS and CUPY_NUM_NVCC_THREADS to NIX_BUILD_CORES results in
  # a small amount of thrashing but it turns out there are a large number of
  # very short builds and a few extremely long ones, so setting both ends up
  # working nicely in practice.
  preConfigure = ''
    export CUPY_NUM_BUILD_JOBS="$NIX_BUILD_CORES"
    export CUPY_NUM_NVCC_THREADS="$NIX_BUILD_CORES"
  '';

  nativeBuildInputs = [
    setuptools
    wheel
    addDriverRunpath
    cython_0
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    cudatoolkit-joined
    cudnn
    cutensor
    nccl
  ];

  NVCC = "${lib.getExe cudaPackages.cuda_nvcc}"; # FIXME: splicing/buildPackages
  CUDA_PATH = "${cudatoolkit-joined}";

  propagatedBuildInputs = [
    fastrlock
    numpy
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
      addDriverRunpath "$lib"
    done
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "NumPy-compatible matrix library accelerated by CUDA";
    homepage = "https://cupy.chainer.org/";
    changelog = "https://github.com/cupy/cupy/releases/tag/v${version}";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ hyphon81 ];
  };
}
